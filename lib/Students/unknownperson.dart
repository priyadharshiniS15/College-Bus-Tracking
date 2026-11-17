import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';


void main() {
  runApp(MaterialApp(
    home: unknownperson(),
  ));
}

class unknownperson extends StatefulWidget {
  const unknownperson({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<unknownperson> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController addressc = TextEditingController();
  final TextEditingController locationc = TextEditingController();
  final TextEditingController mobilec = TextEditingController();
  final TextEditingController timecontroller = TextEditingController();
  final TextEditingController datecontroller = TextEditingController();
  String latitude = '';
  String longitude = '';
  late String _selectedCategory;
  final List<String> _categories = ['Fruits', 'Vegetables', 'Nuts & spices', 'Cereals'];

  File? _imageFile;
  DateTime currentDate = DateTime.now();
  late String formattedDate;
  late String formattedTime;




  String location ='Null, Press Button';
  String Address = 'search';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
   String local= '${place.locality}';

    setState(()  {

     addressc .text=Address;
      locationc.text=local;

    });
  }











  @override
  void initState() {
    super.initState();
    // Formatting the current date into a single string with the desired format
    formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    datecontroller.text=formattedDate;
    // Use the formatted date as needed
    print('Formatted Date: $formattedDate');
    formattedTime = DateFormat('HH:mm:ss').format(currentDate);
    timecontroller.text=formattedTime;
    _initializeLocation();

  }

  Future<void> _initializeLocation() async {
    try {
      Position position = await _getGeoLocationPosition();
            location ='Lat: ${position.latitude} , Long: ${position.longitude}';
              GetAddressFromLatLong(position);

    } catch (e) {
      print('Error initializing location: $e');
    }
  }









  //
  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     setState(() {
  //       latitude = position.latitude.toString();
  //       longitude = position.longitude.toString();
  //       print('Latitude: ${position.latitude}');
  //       print('Longitude: ${position.longitude}');
  //
  //     });
  //   } catch (e) {
  //     print('Error getting location: $e');
  //   }
  // }

  Future<void> _saveProduct() async {
    var data = {
      "pname": _productNameController.text,
      "des": _descriptionController.text,
      "address": addressc.text,
      "location": locationc.text,
      "mobile": mobilec.text,
      "time": timecontroller.text,

      "date": datecontroller.text,
      "status1": 'request',
      "status2": 'request',

    };

    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String? userId = user?.uid;



      DatabaseReference _database = FirebaseDatabase.instance.reference();
      String? dataKey = _database.child('Application').push().key;
      await _database.child('Application').child(userId! + dataKey!).set({
        "pname": _productNameController.text,
        "des": _descriptionController.text,
        "address": addressc.text,
        "mobile": mobilec.text,
        "location": locationc.text,
        "status1": 'request',
        "status2": 'request',
        "time": timecontroller.text,
        "date": datecontroller.text,
        "udkey": userId! + dataKey!,
        "pkey": userId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Submit Successfully',
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

      _productNameController.clear();
      _descriptionController.clear();

      mobilec.clear();





      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      print('Error saving product: $e');
      // Handle error saving product
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
            // Implement action for the unknown person button
            print('Unknown Person Button Pressed');
          },
          icon: CircleAvatar(
            child: Icon(Icons.person_outline),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Patient Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: locationc,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextFormField(
              controller: addressc,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: mobilec,
              decoration: InputDecoration(labelText: 'mobile'),
            ),
            TextFormField(
              controller: datecontroller,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextFormField(
              controller: timecontroller,
              decoration: InputDecoration(labelText: 'time'),
            ),


          ],
        ),
      ),
    );
  }
}
