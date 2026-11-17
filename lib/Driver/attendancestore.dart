/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AttendanceHistory extends StatefulWidget {
  final String? dname;
  final String? did;
  final String? scannedData;
  final String? mobile;
  final String? ukey;

  const AttendanceHistory({
    Key? key,
    this.dname,
    this.did,
    this.scannedData,
    this.mobile,
    this.ukey,
  }) : super(key: key);

  @override
  _AttendanceHistoryState createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref().child("Attendance");

  @override
  void initState() {
    super.initState();
    _storeAttendanceData();
    print(widget.dname);
    print(widget.ukey);
  }

  Future<void> _storeAttendanceData() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;

    if (userId == null) {
      print("User not logged in.");
      return;
    }

    try {
      // Reference to Tracking node
      DatabaseReference trackingRef = FirebaseDatabase.instance.ref().child("Tracking");

      // Get the snapshot
      DataSnapshot snapshot = await trackingRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> trackingData = snapshot.value as Map<dynamic, dynamic>;

        Map<String, dynamic>? matchedRecord;

        // Search for the matching record using userId as dkey
        trackingData.forEach((key, value) {
          if (value["dkey"] == userId) {
            matchedRecord = Map<String, dynamic>.from(value);
          }
        });

        if (matchedRecord != null) {
          await _databaseRef.push().set({
            'drivername': widget.dname,
            'driverid': widget.did,
            'ukey': userId,
            'scannedData': widget.scannedData,
            'status': 'request',
            'timestamp': DateTime.now().toIso8601String(),

            // Tracking details
            'date': matchedRecord!["date"],
            'mobile': matchedRecord!["mobile"],
            'path': matchedRecord!["path"],
            'rna': matchedRecord!["rna"],
            'rno': matchedRecord!["rno"],
            'status1': matchedRecord!["status1"],
            'status2': matchedRecord!["status2"],
            'time': matchedRecord!["time"],
          });

          print("Attendance with tracking data recorded successfully.");
        } else {
          print("No matching tracking record found for userId: $userId");
        }
      } else {
        print("Tracking data not found.");
      }
    } catch (e) {
      print("Error storing attendance: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance History')),
      body: StreamBuilder(
        stream: _databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text("No attendance records found."));
          }

          Map<dynamic, dynamic> records =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          List<Map<String, dynamic>> attendanceList = records.entries
              .map((entry) => {
            "scannedData": entry.value["scannedData"] ?? "Unknown",
            "timestamp": entry.value["timestamp"] ?? "No timestamp",
          })
              .toList()
              .reversed
              .toList();

          return ListView.builder(
            itemCount: attendanceList.length,
            itemBuilder: (context, index) {
              var record = attendanceList[index];
              return ListTile(
                title: Text(record['scannedData']!),
                subtitle: Text(record['timestamp']!),
              );
            },
          );
        },
      ),
    );
  }
}
*//*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AttendanceHistory extends StatefulWidget {
  final String? dname;
  final String? did;
  final String? scannedData;
  final String? mobile;
  final String? ukey;

  const AttendanceHistory({
    Key? key,
    this.dname,
    this.did,
    this.scannedData,
    this.mobile,
    this.ukey,
  }) : super(key: key);

  @override
  _AttendanceHistoryState createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref().child("Attendance");

  @override
  void initState() {
    super.initState();
    _storeAttendanceData();
    print(widget.dname);
    print(widget.ukey);
  }

  Future<void> _storeAttendanceData() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;

    if (userId == null) {
      print("User not logged in.");
      return;
    }

    try {
      DatabaseReference trackingRef = FirebaseDatabase.instance.ref().child("Tracking");
      DataSnapshot snapshot = await trackingRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> trackingData = snapshot.value as Map<dynamic, dynamic>;

        Map<String, dynamic>? matchedRecord;

        trackingData.forEach((key, value) {
          if (value["dkey"] == userId) {
            matchedRecord = Map<String, dynamic>.from(value);
          }
        });

        if (matchedRecord != null) {
          await _databaseRef.push().set({
            'drivername': widget.dname,
            'driverid': widget.did,
            'ukey': userId,
            'scannedData': widget.scannedData,
            'status': 'request',
            'timestamp': DateTime.now().toIso8601String(),
            'date': matchedRecord!["date"],
            'mobile': matchedRecord!["mobile"],
            'path': matchedRecord!["path"],
            'rna': matchedRecord!["rna"],
            'rno': matchedRecord!["rno"],
            'status1': matchedRecord!["status1"],
            'status2': matchedRecord!["status2"],
            'time': matchedRecord!["time"],
          });

          print("Attendance with tracking data recorded successfully.");
        } else {
          print("No matching tracking record found for userId: $userId");
        }
      } else {
        print("Tracking data not found.");
      }
    } catch (e) {
      print("Error storing attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Records',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: StreamBuilder(
          stream: _databaseRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                ),
              );
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No attendance records found",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            Map<dynamic, dynamic> records =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            List<Map<String, dynamic>> attendanceList = records.entries
                .map((entry) => {
              "key": entry.key,
              "scannedData": entry.value["scannedData"] ?? "Unknown",
              "timestamp": entry.value["timestamp"] ?? DateTime.now().toIso8601String(),
              "drivername": entry.value["drivername"] ?? "Unknown",
              "date": entry.value["date"] ?? "No date",
              "time": entry.value["time"] ?? "No time",
            })
                .toList()
                .reversed
                .toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: attendanceList.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  var record = attendanceList[index];
                  DateTime dateTime = DateTime.parse(record['timestamp']!);
                  String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
                  String formattedTime = DateFormat('hh:mm a').format(dateTime);

                  return Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.indigo.shade800,
                        ),
                      ),
                      title: Text(
                        record['scannedData']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),

                          Text(
                            'Date: ${record['date']} at ${record['time']}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AttendanceHistory extends StatefulWidget {
  final String? dname;
  final String? did;
  final String? scannedData;
  final String? mobile;
  final String? ukey;

  const AttendanceHistory({
    Key? key,
    this.dname,
    this.did,
    this.scannedData,
    this.mobile,
    this.ukey,
  }) : super(key: key);

  @override
  _AttendanceHistoryState createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child("Attendance");
  final DatabaseReference _studentsRef = FirebaseDatabase.instance.ref().child("Student");
  bool _isEligible = false;
  bool _isLoading = true;
  String _message = '';
  Map<String, dynamic>? _studentData;

  @override
  void initState() {
    super.initState();
    _verifyStudentAndStoreAttendance();
  }

  Future<void> _verifyStudentAndStoreAttendance() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;

    if (userId == null) {
      setState(() {
        _isLoading = false;
        _message = "User not logged in.";
      });
      return;
    }

    try {
      // First verify the student exists and get their data
      DataSnapshot studentSnapshot = await _studentsRef
          .orderByChild('idno')
          .equalTo(widget.scannedData)
          .once()
          .then((event) => event.snapshot);

      if (studentSnapshot.exists) {
        // Student found, get their data
        Map<dynamic, dynamic> students = studentSnapshot.value as Map<dynamic, dynamic>;
        var studentEntry = students.entries.first;
        _studentData = Map<String, dynamic>.from(studentEntry.value);

        // Now get the driver's tracking data
        DatabaseReference trackingRef = FirebaseDatabase.instance.ref().child("Tracking");
        DataSnapshot trackingSnapshot = await trackingRef.get();

        if (trackingSnapshot.exists) {
          Map<dynamic, dynamic> trackingData = trackingSnapshot.value as Map<dynamic, dynamic>;
          Map<String, dynamic>? matchedRecord;

          trackingData.forEach((key, value) {
            if (value["dkey"] == userId) {
              matchedRecord = Map<String, dynamic>.from(value);
            }
          });

          if (matchedRecord != null) {
            // Store attendance with both student and tracking data
            await _databaseRef.push().set({
              'drivername': widget.dname,
              'driverid': widget.did,
              'ukey': userId,
              'scannedData': widget.scannedData,
              'status': 'approved',
              'timestamp': DateTime.now().toIso8601String(),

              // Student details
              'student_name': _studentData!['name'],
              'student_rollno': _studentData!['rollno'],
              'student_department': _studentData!['department'],
              'student_year': _studentData!['year'],
              'student_location': _studentData!['location'],

              // Tracking details
              'date': matchedRecord!["date"],
              'mobile': matchedRecord!["mobile"],
              'path': matchedRecord!["path"],
              'rna': matchedRecord!["rna"],
              'rno': matchedRecord!["rno"],
              'status1': matchedRecord!["status1"],
              'status2': matchedRecord!["status2"],
              'time': matchedRecord!["time"],
            });

            setState(() {
              _isEligible = true;
              _message = 'Attendance recorded successfully!';
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _message = 'No matching route found for this driver.';
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _message = 'No tracking data found.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _message = 'Student ID not found or not eligible for bus travel.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Error processing attendance: $e';
      });
      print("Error storing attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance Records',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isEligible ? Icons.check_circle : Icons.error,
                size: 80,
                color: _isEligible ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: TextStyle(
                  fontSize: 18,
                  color: _isEligible ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (_studentData != null) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.indigo),
                          title: Text('Name'),
                          subtitle: Text(_studentData!['name'] ?? 'N/A'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.confirmation_number, color: Colors.indigo),
                          title: Text('Roll No'),
                          subtitle: Text(_studentData!['rollno'] ?? 'N/A'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.school, color: Colors.indigo),
                          title: Text('Department'),
                          subtitle: Text(_studentData!['department'] ?? 'N/A'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.calendar_today, color: Colors.indigo),
                          title: Text('Year'),
                          subtitle: Text(_studentData!['year'] ?? 'N/A'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo.shade800,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Back to Scanner',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}