/*

import 'dart:async';
import 'package:collegebustracking/Students/seat.dart';
import 'package:collegebustracking/Students/tracklocation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(UserApply());
}

class UserApply extends StatefulWidget {
  @override
  State<UserApply> createState() => _AmbulanceHomeState();
}

class _AmbulanceHomeState extends State<UserApply> {
  String? selectedRoute;
  String? selectedVehicle;
  late Timer timer;
  late Position currentPosition;
  DateTime currentDate = DateTime.now();
  late String formattedDate;
  late String formattedTime;
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late TextEditingController textController4;
  bool isTextController1NotEmpty = false;
  String akey = '';
  String mob = '';
  String seat = '';
  String rna = '';
  String rno = '';
  String date='';
  String busno='';
  String path='';

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    textController1.addListener(updateVisibility);
    formattedTime = DateFormat('HH:mm:ss').format(currentDate);
  }

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    textController3.dispose();
    textController4.dispose();
    super.dispose();
  }

  void updateVisibility() {
    setState(() {
      isTextController1NotEmpty = textController1.text.isNotEmpty;
    });
  }

  Future<void> fetchdata() async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.reference().child('Tracking');
      setState(() {
        isTextController1NotEmpty = textController1.text.isNotEmpty;
      });


      reference.onValue.listen((event) {
        if (event.snapshot.value != null) {
          var outerMap = event.snapshot.value as Map<Object?, Object?>?;
          if (outerMap != null && outerMap.isNotEmpty) {
            // Iterate through all buses
            outerMap.forEach((key, value) {
              var innerMap = value as Map<Object?, Object?>?;
              if (innerMap != null) {
                String routeStops = innerMap['rno']?.toString() ?? '';

                // Check if selected route is in the bus's route stops
                if (selectedRoute != null && routeStops.contains(selectedRoute!)) {
                  setState(() {
                    rna = innerMap['rna']?.toString() ?? 'Unknown RNA';
                    busno = innerMap['busno']?.toString() ?? 'Unknown Bus No';
                    path = innerMap['path']?.toString() ?? 'Unknown Bus No';
                    rno = routeStops;
                    mob = innerMap['mobile']?.toString() ?? '';
                    akey = innerMap['dkey']?.toString() ?? 'Unknown Key';
                    seat = innerMap['seat']?.toString() ?? 'Unknown Seats';
                    date = innerMap['date']?.toString() ?? 'Unknown Date';

                    textController1.text = rna;
                    textController2.text = rno;
                    textController3.text = busno;
                    textController4.text=path;
                  });
                  return; // Exit after finding the first matching bus
                }
              }
            });
          }
        } else {
          print('No location data found in the database');
        }
      }, onError: (Object error) {
        print('Error fetching location data: $error');
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _launchPhoneCall(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch phone call');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  */
/*gradient: LinearGradient(
                    colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),*//*

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/1.png',
                    width: 150,
                    height: 150,

                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'College Bus Tracking',
                style: TextStyle(
                  color: Color(0xFF2575FC),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Select your route to track the bus',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedRoute,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRoute = newValue;
                    });
                    fetchdata();
                  },
                  items: [
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
                    'New bus stop',
                    'Old bus stop',
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
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    'Select Route',
                    style: TextStyle(color: Colors.grey),
                  ),
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF2575FC)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: textController1,
                  decoration: InputDecoration(
                    labelText: 'Bus Name',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: textController3,
                  decoration: InputDecoration(
                    labelText: 'Bus Number',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: textController2,
                  decoration: InputDecoration(
                    labelText: 'Route',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: textController4,
                  decoration: InputDecoration(
                    labelText: 'Path',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Visibility(
                visible: isTextController1NotEmpty,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (mob.isNotEmpty) {
                        _launchPhoneCall(mob);
                      } else {
                        print('No phone number available');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2575FC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Call Driver',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackLocation(akey: akey),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6A11CB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_bus, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Track Bus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatAvailability(



                            akey: akey,
                            seat: seat,
                            busno: rna,
                            route: rno,
                            date: date,




                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00C853),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_seat, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Seat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'dart:async';
import 'package:collegebustracking/Students/seat.dart';
import 'package:collegebustracking/Students/tracklocation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Trackbusssss());
}

class Trackbusssss extends StatefulWidget {
  @override
  State<Trackbusssss> createState() => _AmbulanceHomeState();
}

class _AmbulanceHomeState extends State<Trackbusssss> {
  String? selectedRoute;
  String? selectedVehicle;
  late Timer timer;
  late Position currentPosition;
  DateTime currentDate = DateTime.now();
  late String formattedDate;
  late String formattedTime;
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late TextEditingController textController4;
  bool isTextController1NotEmpty = false;
  String akey = '';
  String mob = '';
  String seat = '';
  String rna = '';
  String rno = '';
  String date = '';
  String busno = '';
  String path = '';

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    textController4 = TextEditingController();
    textController1.addListener(updateVisibility);
    formattedTime = DateFormat('HH:mm:ss').format(currentDate);
  }

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    textController3.dispose();
    textController4.dispose();
    super.dispose();
  }

  void updateVisibility() {
    setState(() {
      isTextController1NotEmpty = textController1.text.isNotEmpty;
    });
  }

  Future<void> fetchdata() async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.reference().child('Tracking');
      setState(() {
        isTextController1NotEmpty = textController1.text.isNotEmpty;
      });

      // Listen to all tracking data
      reference.onValue.listen((event) {
        if (event.snapshot.value != null) {
          var outerMap = event.snapshot.value as Map<Object?, Object?>?;
          if (outerMap != null && outerMap.isNotEmpty) {
            // Iterate through all buses
            outerMap.forEach((key, value) {
              var innerMap = value as Map<Object?, Object?>?;
              if (innerMap != null) {
                String routeStops = innerMap['rno']?.toString() ?? '';

                // Check if selected route is in the bus's route stops
                if (selectedRoute != null && routeStops.contains(selectedRoute!)) {
                  setState(() {
                    rna = innerMap['rna']?.toString() ?? 'Unknown RNA';
                    busno = innerMap['busno']?.toString() ?? 'Unknown Bus No';
                    path = innerMap['path']?.toString() ?? 'Unknown Bus No';
                    rno = routeStops;
                    mob = innerMap['mobile']?.toString() ?? '';
                    akey = innerMap['dkey']?.toString() ?? 'Unknown Key';
                    seat = innerMap['seat']?.toString() ?? 'Unknown Seats';
                    date = innerMap['date']?.toString() ?? 'Unknown Date';

                    textController1.text = rna;
                    textController2.text = rno;
                    textController3.text = busno;
                    textController4.text = path;
                  });
                  return; // Exit after finding the first matching bus
                }
              }
            });
          }
        } else {
          print('No location data found in the database');
        }
      }, onError: (Object error) {
        print('Error fetching location data: $error');
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  /*void _launchPhoneCall(String phoneNumber) async {
    final String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch phone call');
    }
  }*/


  Future<void> _launchPhoneCall(String phoneNumber) async {
    try {
      // Check and request phone permission
      if (!await _requestPhonePermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone permission denied')),
        );
        return;
      }

      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      // For direct calling (requires CALL_PHONE permission)
      await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );

    } catch (e) {
      print('Error making phone call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not make the call: ${e.toString()}')),
      );
    }
  }

  Future<bool> _requestPhonePermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.0),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/1.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'College Bus Tracking',
                style: TextStyle(
                  color: Color(0xFF2575FC),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Select your route to track the bus',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedRoute,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRoute = newValue;
                    });
                    // Clear previous data when a new route is selected
                    textController1.clear();
                    textController2.clear();
                    textController3.clear();
                    textController4.clear();
                    fetchdata();
                  },
                  items: [
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
                    'Urrappakam',
                    'Guduvanjeri',
                    'Sp Kovil',
                    'Perumgalathoor',
                    'Thambaram',
                    'Chromebet',
                    'Chennai',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: Text(
                    'Select Route',
                    style: TextStyle(color: Colors.grey),
                  ),
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF2575FC)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: textController1,
                  readOnly: true, // Make it non-editable
                  decoration: InputDecoration(
                    labelText: 'Bus Name',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextField(
                      controller: textController2,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Route',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: textController2.text.isNotEmpty
                            ? textController2.text.split(',').map((item) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              item.trim(),
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList()
                            : [Text('No data available')],
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: textController3,
                  readOnly: true, // Make it non-editable
                  decoration: InputDecoration(
                    labelText: 'Bus Number',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: textController4,
                  readOnly: true, // Make it non-editable
                  decoration: InputDecoration(
                    labelText: 'Path',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Visibility(
                visible: isTextController1NotEmpty,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (mob.isNotEmpty) {
                        _launchPhoneCall(mob);
                      } else {
                        print('No phone number available');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2575FC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Call Driver',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackLocation(akey: akey),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6A11CB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_bus, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Track Bus',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeatAvailability(
                          akey: akey,
                          seat: seat,
                          busno: rna,
                          route: rno,
                          date: date,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00C853),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_seat, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Seat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
