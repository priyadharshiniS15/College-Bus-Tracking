import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ambusertrack extends StatefulWidget {

  final String pkey;

  ambusertrack({

    required this.pkey,

  });

  @override
  _FullListPageState createState() => _FullListPageState();
}

class _FullListPageState extends State<ambusertrack> {
  String selectedRadio = ''; // Variable to hold the selected radio value
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  late GoogleMapController mapController;

  DatabaseReference reference = FirebaseDatabase.instance.reference();
  StreamController<Map<String, dynamic>> _locationStreamController =
  StreamController<Map<String, dynamic>>();
  Uint8List? compressedBytes; // Declare compressedBytes here

  @override
  void initState() {
    super.initState();
    startLocationUpdates();
    loadCompressedBytes(); // Load compressed bytes when the widget initializes
  }

  @override
  void dispose() {
    _locationStreamController.close();
    super.dispose();
  }

  Future<void> loadCompressedBytes() async {
    // Load the image byte data
    ByteData data = await rootBundle.load('assets/images/ambulance.png');

    // Convert List<int> to Uint8List
    Uint8List originalBytes = Uint8List.fromList(data.buffer.asUint8List());

    // Compress the image to reduce size
    compressedBytes = await FlutterImageCompress.compressWithList(
      originalBytes,
      minHeight: 68, // Set your desired height
      minWidth: 68, // Set your desired width
      quality: 80, // Set your desired quality (0 to 100)
    );
  }

  void startLocationUpdates() {
    DatabaseReference reference =
    FirebaseDatabase.instance.reference().child('locations').child(widget.pkey);

    reference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        var userData = event.snapshot.value;
        // Use null-aware cast to Map<String, dynamic>
        if (userData is Map<Object?, Object?>) {
          // Cast the map to Map<String, dynamic>
          Map<String, dynamic> userDataMap = userData.cast<String, dynamic>();

          // Add the data to the stream
          _locationStreamController.add(userDataMap);

          // Show location on the map continuously
          showLocationOnMap(userDataMap['latitude'], userDataMap['longitude']);
        } else {
          print("Invalid data structure in the database");
        }
      } else {
        print("No location data found in the database");
      }
    }, onError: (Object error) {
      print("Error fetching location data: $error");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body:
      StreamBuilder<Map<String, dynamic>>(
        stream: _locationStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double? latitude = snapshot.data!['latitude'];
            double? longitude = snapshot.data!['longitude'];
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude!, longitude!),
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                markers: {
                  Marker(
                    markerId: MarkerId('locationMarker'),
                    position: LatLng(latitude, longitude),
                    icon: BitmapDescriptor.fromBytes(compressedBytes!),
                    infoWindow: InfoWindow(title: 'Student Location'),
                  ),
                },
              ),
            );
          } else {
            // Show loading or default map
            return Container();
          }
        },
      ),
    );




  }

  void showLocationOnMap(double? latitude, double? longitude) {
    // Check if mapController is initialized
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latitude!, longitude!),
          14.0,
        ),
      );
    }
  }
}