import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AmbulanceHome());
}

class AmbulanceHome extends StatefulWidget {
  final String? ukey;
  final String? dname;
  final String? did;
  final String? mobile;
  const AmbulanceHome({super.key, this.ukey, this.dname, this.did, this.mobile});

  @override
  State<AmbulanceHome> createState() => _AmbulanceHomeState();
}

class _AmbulanceHomeState extends State<AmbulanceHome> {
  String? ct;
  String? selectedRoute;
  String? selectedVehicle;
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _busNoController = TextEditingController();
  late Timer timer;
  late Position currentPosition;
  DateTime currentDate = DateTime.now();
  late String formattedDate;
  late String formattedTime;

  // Define the routes for each bus
  final Map<String, List<String>> busRoutes = {
    'A': [
      'veltech College',
      'Padalam x road',
      'Palayanur',
      'Pukkathurai',
      'Mamandoor',
      'Palaar Checkpost',
      'Vidyasagar',
      'New collector office',
      'ITI',
      'COURT',
      'GH',
      'Ratna kenar',
      'New bus stop (CPT)',
      'Old bus stop (CPT)',

    ],
    'B': [
      'veltech College',
      'Padalam',
      'Salavakkam',
      'Nelvay x road',
      'Uthiramerur',
      'Karani mandabam',
      'Vayaloor x road',
      'Manambathy',
      'Melma x road',
      'Pudhoor',
      'Vandavasi',
    ],
    'C': [
      'veltech College',
      'Padalam x road',
      'Palayanur',
      'Pukkathurai',
      'Mamandoor',
      'Palaar Checkpost',
      'Vidyasagar',
      'New collector office',
      'ITI',
      'COURT',
      'GH',
      'Ratna kenar',
      'New bus stop (CPT)',
      'Old bus stop (CPT)',
      'Urrappakam',
      'Guduvanjeri',
      'Sp Kovil',
      'Perumgalathoor',
      'Thambaram',
      'Chromebet',
      'Chennai',
    ],
  };

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    formattedTime = DateFormat('HH:mm:ss').format(currentDate);
  }

  Future<void> _saveProduct() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String? userId = user?.uid;

      DatabaseReference _database = FirebaseDatabase.instance.reference();

      await _database.child('Tracking').child(userId!).set({
        "dname": widget.dname,
        "mobile": widget.mobile,
        "seat": _busNameController.text,
        "busno": _busNoController.text,
        "did": widget.did,
        "rno": selectedVehicle != null && busRoutes[selectedVehicle] != null
            ? busRoutes[selectedVehicle]!.join(', ')
            : '',
        "rna": selectedVehicle,
        "path": ct,
        "status1": 'request',
        "status2": 'request',
        "time": formattedTime,
        "date": formattedDate,
        "dkey": userId,
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Update Successfully',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(20),
        ),
      );

      setState(() {
        selectedRoute = null;
        selectedVehicle = null;
        ct = null;
        _busNameController.clear();
        _busNoController.clear();
      });
    } catch (e) {
      print('Error saving product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_bus_rounded,
                      size: 80,
                      color: Colors.indigo[800],
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Bus Services',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo[800],
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Update Bus Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Route Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Path',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: ct,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            ct = newValue;
                            selectedRoute = null; // Reset route when path changes
                          });
                        },
                        items: [
                          'College to Route',
                          'Route to College',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text(
                          'Select Path',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Today\'s Route',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedRoute,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRoute = newValue;
                          });
                        },
                        items: selectedVehicle != null && busRoutes.containsKey(selectedVehicle)
                            ? busRoutes[selectedVehicle]!.map((route) {
                          return DropdownMenuItem<String>(
                            value: route,
                            child: Text(route),
                          );
                        }).toList()
                            : [],
                        hint: Text(
                          selectedVehicle != null
                              ? 'Select Route for Bus $selectedVehicle'
                              : 'Select Vehicle first',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Select Vehicle',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: selectedVehicle,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(Icons.arrow_drop_down),
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedVehicle = newValue;
                            selectedRoute = null; // Reset route when vehicle changes
                          });
                        },
                        items: busRoutes.keys.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('Bus $value'),
                          );
                        }).toList(),
                        hint: Text(
                          'Select Vehicle',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      controller: _busNameController,
                      label: 'Seat Count',
                      hint: 'Enter Seat Count',
                      icon: Icons.event_seat,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Seat Count';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      controller: _busNoController,
                      label: 'Vehicle Number',
                      hint: 'Enter Vehicle Number',
                      icon: Icons.bus_alert,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Vehicle Number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProduct,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Update Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}