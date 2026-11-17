import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StudentApprovalApp());
}

class StudentApprovalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Approval',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: StudentApprovalPage(),
    );
  }
}

class Student {
  final String id;
  final String email;
  final String name;
  final String rollno;
  final String location;
  final String status;

  Student({
    required this.id,
    required this.email,
    required this.name,
    required this.rollno,
    required this.location,
    required this.status,
  });

  factory Student.fromMap(Map<dynamic, dynamic> data, String id) {
    return Student(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      rollno: data['rollno'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? 'request',
    );
  }
}

class StudentApprovalPage extends StatefulWidget {
  @override
  _StudentApprovalPageState createState() => _StudentApprovalPageState();
}

class _StudentApprovalPageState extends State<StudentApprovalPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Student');
  List<Student> _studentsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  void _fetchStudentData() {
    _dbRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.exists) {
        List<Student> students = [];
        Map<dynamic, dynamic> studentsData = dataSnapshot.value as Map<dynamic, dynamic>;
        studentsData.forEach((key, value) {
          Student student = Student.fromMap(value, key.toString());
          if (student.status == 'request') {
            students.add(student);
          }
        });

        setState(() {
          _studentsList = students;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _approveStudent(String studentId) async {
    try {
      await _dbRef.child(studentId).update({'status': 'approved'});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student approved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Refresh the list after approval
      _fetchStudentData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to approve student: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Approval Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
          ),
        )
            : _studentsList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school,
                size: 60,
                color: Colors.blue[200],
              ),
              SizedBox(height: 20),
              Text(
                'No Pending Requests',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'All student requests have been processed',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: () async {
            _fetchStudentData();
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: _studentsList.length,
            itemBuilder: (context, index) {
              return _buildStudentCard(_studentsList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Roll No: ${student.rollno}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Pending',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoRow(Icons.email, 'Email', student.email),
              _buildInfoRow(Icons.numbers, 'Roll No', student.rollno),
              _buildInfoRow(Icons.location_on, 'Location', student.location),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[800],
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _approveStudent(student.id),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Approve Student',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blue[600],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}