/*
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'adminhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Attendance());
}

class Attendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Details',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AttendanceListPage(),
    );
  }
}

class Student {
  final String name;
  final String id;
  final String status;

  Student({
    required this.name,
    required this.id,
    required this.status,
  });

  factory Student.fromMap(Map<dynamic, dynamic> data, String id) {
    return Student(
      name: data['name'] ?? 'Unknown',
      id: id,
      status: data['status'] ?? 'Unknown',
    );
  }
}

class AttendanceListPage extends StatefulWidget {
  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  final DatabaseReference _attendanceRef =
  FirebaseDatabase.instance.ref().child('Attendance');
  final DatabaseReference _studentRef =
  FirebaseDatabase.instance.ref().child('Students');

  List<Student> _studentsList = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  void _fetchAttendanceData() async {
    DatabaseEvent event = await _attendanceRef.once();
    final attendanceSnapshot = event.snapshot;

    if (attendanceSnapshot.exists) {
      Map<dynamic, dynamic> attendanceData =
      attendanceSnapshot.value as Map<dynamic, dynamic>;

      for (var key in attendanceData.keys) {
        var data = attendanceData[key];

        // Extract scannedData from attendance entry
        String scannedData = data['scannedData'] ?? '';

        // Find matching student based on scannedData
        _matchStudent(scannedData);
      }
    }
  }

  void _matchStudent(String scannedData) async {
    DatabaseEvent studentEvent = await _studentRef.once();
    final studentSnapshot = studentEvent.snapshot;

    if (studentSnapshot.exists) {
      Map<dynamic, dynamic> studentData =
      studentSnapshot.value as Map<dynamic, dynamic>;

      for (var key in studentData.keys) {
        var student = studentData[key];

        if (student['rollno'] == scannedData) {
          setState(() {
            _studentsList.add(Student.fromMap(student, key));
          });
          return;
        }
      }
    }

    // If no student found, show an error message
    setState(() {
      _studentsList.add(Student(name: 'Not Found', id: scannedData, status: 'N/A'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Details'),
          backgroundColor: Colors.blueAccent,
        ),
        body: _studentsList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _studentsList.length,
          itemBuilder: (context, index) {
            return _buildStudentCard(_studentsList[index]);
          },
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.person, "Student Name", student.name),
            _buildDetailRow(Icons.badge, "Student ID", student.id),
            _buildDetailRow(Icons.local_activity, "Status", student.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminHomePage()),
    );
    return false;
  }
}
*/
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'adminhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Attendance());
}

class Attendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ), // <- This was misaligned
      home: AttendanceListPage(),
    );
  }
}


class Student {
  final String name;
  final String id;
  final String status;
  final String rollno;
  final String department;
  final String year;
  final String date;
  final String time;
  final String location;
  final String path;

  Student({
    required this.name,
    required this.id,
    required this.status,
    required this.rollno,
    required this.department,
    required this.year,
    required this.date,
    required this.time,
    required this.location,
    required this.path,
  });

  factory Student.fromMap(Map<dynamic, dynamic> data, String id) {
    return Student(
      name: data['student_name'] ?? 'Unknown',
      id: id,
      status: data['status'] ?? 'Unknown',
      rollno: data['student_rollno']?.toString() ?? 'Unknown',
      department: data['student_department'] ?? 'Unknown',
      year: data['student_year'] ?? 'Unknown',
      date: data['date'] ?? 'Unknown',
      time: data['time'] ?? 'Unknown',
      location: data['student_location'] ?? 'Unknown',
      path: data['path'] ?? 'Unknown',
    );
  }
}

class AttendanceListPage extends StatefulWidget {
  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  final DatabaseReference _attendanceRef =
  FirebaseDatabase.instance.ref().child('Attendance');

  List<Student> _studentsList = [];
  List<Student> _filteredList = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedDepartment = 'All';
  String _selectedYear = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  void _fetchAttendanceData() async {
    try {
      DatabaseEvent event = await _attendanceRef.once();
      final attendanceSnapshot = event.snapshot;

      if (attendanceSnapshot.exists) {
        Map<dynamic, dynamic> attendanceData =
        attendanceSnapshot.value as Map<dynamic, dynamic>;

        List<Student> tempList = [];

        attendanceData.forEach((key, value) {
          tempList.add(Student.fromMap(value, key));
        });

        setState(() {
          _studentsList = tempList;
          _filteredList = tempList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _filterStudents() {
    setState(() {
      _filteredList = _studentsList.where((student) {
        final matchesSearch = student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            student.rollno.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            student.id.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesDepartment = _selectedDepartment == 'All' ||
            student.department == _selectedDepartment;

        final matchesYear = _selectedYear == 'All' ||
            student.year == _selectedYear;

        return matchesSearch && matchesDepartment && matchesYear;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final departments = _getUniqueValues('department');
    final years = _getUniqueValues('year');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Details'),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _searchQuery = '';
                  _selectedDepartment = 'All';
                  _selectedYear = 'All';
                  _searchController.clear();
                });
                _fetchAttendanceData();
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, roll no or ID',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _filterStudents();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDepartment,
                      decoration: InputDecoration(
                        labelText: 'Department',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: ['All', ...departments].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value!;
                        });
                        _filterStudents();
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedYear,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: ['All', ...years].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                        });
                        _filterStudents();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Records: ${_filteredList.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue[800],
                ),
              ),
            ),
            Expanded(
              child: _filteredList.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'No records found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  return _buildStudentCard(_filteredList[index]);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAdvancedSearchDialog(context);
          },
          child: Icon(Icons.filter_alt),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }

  List<String> _getUniqueValues(String field) {
    Set<String> uniqueValues = {};
    for (var student in _studentsList) {
      switch (field) {
        case 'department':
          uniqueValues.add(student.department);
          break;
        case 'year':
          uniqueValues.add(student.year);
          break;
      }
    }
    return uniqueValues.toList()..sort();
  }

  Widget _buildStudentCard(Student student) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _showStudentDetails(student);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[50]!, Colors.blue[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      student.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(student.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      student.status.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildDetailRow(Icons.confirmation_number, "Roll No", student.rollno),
              _buildDetailRow(Icons.badge, "ID", student.id),
              _buildDetailRow(Icons.school, "Department", "${student.department} - Year ${student.year}"),
              _buildDetailRow(Icons.calendar_today, "Registered", "${student.date} at ${student.time}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue[800]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

/*
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }*/

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late':
        return Colors.orange;
      case 'request':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showStudentDetails(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Student Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailDialogRow("Name", student.name),
              _buildDetailDialogRow("Roll No", student.rollno),
              _buildDetailDialogRow("ID", student.id),
              _buildDetailDialogRow("Department", student.department),
              _buildDetailDialogRow("Year", student.year),
              _buildDetailDialogRow("Status", student.status),
              _buildDetailDialogRow("Date", student.date),
              _buildDetailDialogRow("Time", student.time),
              _buildDetailDialogRow("Location", student.location),
              _buildDetailDialogRow("Path", student.path),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildDetailDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showAdvancedSearchDialog(BuildContext context) {
    final rollNoController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Advanced Search'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: rollNoController,
                decoration: InputDecoration(
                  labelText: 'Search by Roll No',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'Search by ID Card No',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (rollNoController.text.isNotEmpty) {
                setState(() {
                  _searchQuery = rollNoController.text;
                  _selectedDepartment = 'All';
                  _selectedYear = 'All';
                  _searchController.clear();
                });
                _filterStudents();
                Navigator.pop(context);
              } else if (idController.text.isNotEmpty) {
                setState(() {
                  _searchQuery = idController.text;
                  _selectedDepartment = 'All';
                  _selectedYear = 'All';
                  _searchController.clear();
                });
                _filterStudents();
                Navigator.pop(context);
              }
            },
            child: Text('Search'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminHomePage()),
    );
    return false;
  }
}