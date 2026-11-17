/*
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'adminhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DriverApp());
}

class DriverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driver Details',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DriverListPage(),
    );
  }
}

class Driver {
  final String id;
  final String name;
  final String ambnumber;
  final String drivername;
  final String contact;

  Driver({
    required this.id,
    required this.name,
    required this.ambnumber,
    required this.drivername,
    required this.contact,
  });

  factory Driver.fromMap(Map<dynamic, dynamic> data, String id) {
    return Driver(
      id: id,
      name: data['email'] ?? '',
      ambnumber: data['driverid'] ?? '',
      drivername: data['dname'] ?? '',
      contact: data['mobile'] ?? '',
    );
  }
}

class DriverListPage extends StatefulWidget {
  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Driver');
  List<Driver> _driversList = [];

  @override
  void initState() {
    super.initState();
    _fetchDriverData();
  }

  void _fetchDriverData() {
    _dbRef.once().then((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.exists) {
        List<Driver> drivers = [];
        Map<dynamic, dynamic> driversData = dataSnapshot.value as Map<dynamic, dynamic>;
        driversData.forEach((key, value) {
          Driver driver = Driver.fromMap(value, key);
          drivers.add(driver);
        });

        setState(() {
          _driversList = drivers;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Driver Details'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade500],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _driversList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: _driversList.length,
            itemBuilder: (context, index) {
              return _buildDriverCard(_driversList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.shade100,
          child: Icon(Icons.directions_bus, color: Colors.white),
        ),
        title: Text(
          driver.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue.shade700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver Id: ${driver.ambnumber}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),

              Text(
                'Driver E-Mail: ${driver.name}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              Text(
                'Contact: ${driver.contact}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminHomePage(),
      ),
    );
    return false;
  }
}
*//*

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'adminhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DriverApp());
}

class DriverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Approved Drivers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: DriverListPage(),
    );
  }
}

class Driver {
  final String id;
  final String email;
  final String driverId;
  final String name;
  final String contact;
  final String status;

  Driver({
    required this.id,
    required this.email,
    required this.driverId,
    required this.name,
    required this.contact,
    required this.status,
  });

  factory Driver.fromMap(Map<dynamic, dynamic> data, String id) {
    return Driver(
      id: id,
      email: data['email'] ?? '',
      driverId: data['driverid'] ?? '',
      name: data['dname'] ?? '',
      contact: data['mobile'] ?? '',
      status: data['status'] ?? 'request',
    );
  }
}

class DriverListPage extends StatefulWidget {
  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Driver');
  List<Driver> _driversList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDriverData();
  }

  void _fetchDriverData() {
    _dbRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.exists) {
        List<Driver> drivers = [];
        Map<dynamic, dynamic> driversData = dataSnapshot.value as Map<dynamic, dynamic>;
        driversData.forEach((key, value) {
          Driver driver = Driver.fromMap(value, key.toString());
          if (driver.status == 'approved') {  // Only show approved drivers
            drivers.add(driver);
          }
        });

        setState(() {
          _driversList = drivers;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Approved Drivers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
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
              : _driversList.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_bus,
                  size: 60,
                  color: Colors.blue[200],
                ),
                SizedBox(height: 20),
                Text(
                  'No Approved Drivers',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Currently there are no approved drivers',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: () async {
              _fetchDriverData();
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: _driversList.length,
              itemBuilder: (context, index) {
                return _buildDriverCard(_driversList[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
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
                      gradient: LinearGradient(
                        colors: [Colors.blue[600]!, Colors.blue[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ID: ${driver.driverId}',
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
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Approved',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoRow(Icons.email, 'Email', driver.email),
              _buildInfoRow(Icons.phone, 'Contact', driver.contact),
              SizedBox(height: 16),

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

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminHomePage(),
      ),
    );
    return false;
  }
}*/
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for auth deletion
import 'adminhome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DriverApp());
}

class DriverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Driver Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: DriverListPage(),
    );
  }
}
class Driver {
  final String id;
  final String email;
  final String driverId;
  final String name;
  final String contact;
  final String status;

  Driver({
    required this.id,
    required this.email,
    required this.driverId,
    required this.name,
    required this.contact,
    required this.status,
  });

  factory Driver.fromMap(Map<dynamic, dynamic> data, String id) {
    return Driver(
      id: id,
      email: data['email'] ?? '',
      driverId: data['driverid'] ?? '',
      name: data['dname'] ?? '',
      contact: data['mobile'] ?? '',
      status: data['status'] ?? 'request',
    );
  }
}

class DriverListPage extends StatefulWidget {
  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Driver');
  final FirebaseAuth _auth = FirebaseAuth.instance; // Added for auth deletion
  List<Driver> _driversList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDriverData();
  }

  void _fetchDriverData() {
    _dbRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.exists) {
        List<Driver> drivers = [];
        Map<dynamic, dynamic> driversData = dataSnapshot.value as Map<dynamic, dynamic>;
        driversData.forEach((key, value) {
          Driver driver = Driver.fromMap(value, key.toString());
          if (driver.status == 'approved') {
            drivers.add(driver);
          }
        });

        setState(() {
          _driversList = drivers;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _deleteDriver(String driverId, String email) async {
    try {
      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want to delete this driver permanently?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text("Delete", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (confirmDelete != true) {
        return;
      }

      // Delete from Realtime Database
      await _dbRef.child(driverId).remove();

      // Delete from Firebase Authentication
      try {
        User? user = (await _auth.fetchSignInMethodsForEmail(email)).isNotEmpty
            ? _auth.currentUser
            : null;

        if (user != null && user.email == email) {
          await user.delete();
        }
      } catch (e) {
        print("Error deleting user from auth: $e");
        // You might want to handle this case differently
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Driver deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the list
      _fetchDriverData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete driver: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Approved Drivers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[800]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
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
              : _driversList.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_bus,
                  size: 60,
                  color: Colors.blue[200],
                ),
                SizedBox(height: 20),
                Text(
                  'No Approved Drivers',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Currently there are no approved drivers',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
              : RefreshIndicator(
            onRefresh: () async {
              _fetchDriverData();
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: _driversList.length,
              itemBuilder: (context, index) {
                return _buildDriverCard(_driversList[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
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
                      gradient: LinearGradient(
                        colors: [Colors.blue[600]!, Colors.blue[400]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ID: ${driver.driverId}',
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
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Approved',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoRow(Icons.email, 'Email', driver.email),
              _buildInfoRow(Icons.phone, 'Contact', driver.contact),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteDriver(driver.id, driver.email),
                  tooltip: 'Delete Driver',
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

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminHomePage(),
      ),
    );
    return false;
  }
}