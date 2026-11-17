import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: latee(),
  ));
}

class latee extends StatefulWidget {
  const latee({Key? key}) : super(key: key);

  @override
  _LateFormState createState() => _LateFormState();
}

class _LateFormState extends State<latee> {
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latetimeController = TextEditingController();
  final TextEditingController _latereasonController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final List<String> _categories = ['College to Route', 'Route to College'];
  late String _selectedCategory = 'College to Route';

  DateTime currentDate = DateTime.now();
  late String formattedDate;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    _dateController.text = formattedDate;
    formattedTime = DateFormat('HH:mm:ss').format(currentDate);
    _timeController.text = formattedTime;
  }

  Future<void> _saveProduct() async {
    var data = {
      "drivername": _driverNameController.text,
      "busnumber": _busNumberController.text,
      "busname": _busNameController.text,
      "route": _routeController.text,
      "location": _locationController.text,
      "latetime": _latetimeController.text,
      "reason": _latereasonController.text,
      "time": _timeController.text,
      "date": _dateController.text,
      "status1": 'request',
      "status2": 'request',
      "category": _selectedCategory,
    };

    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String? userId = user?.uid;

      DatabaseReference _database = FirebaseDatabase.instance.reference();
      String? dataKey = _database.child('Lateform').push().key;
      await _database.child('Lateform').child(userId!).set({
        "drivername": _driverNameController.text,
        "busnumber": _busNumberController.text,
        "busname": _busNameController.text,
        "route": _routeController.text,
        "mobile": _latetimeController.text,
        "location": _locationController.text,
        "reason": _latereasonController.text,
        "status1": 'request',
        "status2": 'request',
        "time": _timeController.text,
        "date": _dateController.text,
        "udkey": userId! + dataKey!,
        "pkey": userId,
        "category": _selectedCategory,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Submitted Successfully',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue,
          elevation: 4.0,
        ),
      );

      _driverNameController.clear();
      _busNumberController.clear();
      _busNameController.clear();
      _routeController.clear();
      _latetimeController.clear();
      _latereasonController.clear();
      _locationController.clear();
    } catch (e) {
      print('Error saving product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply'),
        actions: [
          IconButton(
            onPressed: _saveProduct,
            icon: Icon(Icons.save),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            print('Unknown Person Button Pressed');
          },
          icon: CircleAvatar(
            child: Icon(Icons.person_outline),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _driverNameController,
                  label: 'Driver Name',
                  icon: Icons.person,
                ),
                _buildTextField(
                  controller: _busNameController,
                  label: 'Bus Name',
                  icon: Icons.directions_bus,
                ),
                _buildTextField(
                  controller: _busNumberController,
                  label: 'Bus Number',
                  icon: Icons.bus_alert,
                ),
                _buildTextField(
                  controller: _routeController,
                  label: 'Route Name',
                  icon: Icons.map,
                ),
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  icon: Icons.location_on,
                ),
                _buildTextField(
                  controller: _latetimeController,
                  label: 'Late Time',
                  icon: Icons.access_time,
                ),
                _buildTextField(
                  controller: _latereasonController,
                  label: 'Reason For Late',
                  icon: Icons.access_time,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Choose Path',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                _buildTextField(
                  controller: _dateController,
                  label: 'Date',
                  icon: Icons.calendar_today,
                  readOnly: true,
                ),
                _buildTextField(
                  controller: _timeController,
                  label: 'Time',
                  icon: Icons.access_time,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        readOnly: readOnly,
      ),
    );
  }
}
