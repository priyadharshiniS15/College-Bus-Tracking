import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
    home: Live(),
  ));
}

class Live extends StatefulWidget {
  const Live({Key? key}) : super(key: key);

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  String userId = "";
  late Timer timer;
  late DatabaseReference dbRef;
  bool isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _requestLocationPermission();
    dbRef = FirebaseDatabase.instance.ref().child('locations');
  }

  Future<void> _initializeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    // Request permission only if not granted
    if (await Permission.location.isGranted) {
      print('Location permission already granted.');
    } else {
      var status = await Permission.location.request();
      if (status.isGranted) {
        print('Location permission granted.');
      } else if (status.isDenied) {
        print('Location permission denied by user.');
        // Optionally, you could redirect the user to the app settings
      }
    }
  }

  Future<void> _updateLocation() async {
    try {
      // Check location permission and services status
      bool permissionGranted = await Permission.location.isGranted;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (permissionGranted && serviceEnabled) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high, // Use high accuracy for better results
        );

        await dbRef.child(userId).set({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': ServerValue.timestamp,
        });
        print('Location updated: ${position.latitude}, ${position.longitude}');
      } else {
        if (!permissionGranted) {
          print('Location permission not granted.');
        }
        if (!serviceEnabled) {
          print('Location services are disabled.');
        }
      }
    } catch (e) {
      print("Error updating location: $e");
    }
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _updateLocation());
  }

  void _stopTimer() {
    timer.cancel();
  }

  @override
  void dispose() {
    if (isTimerRunning) {
      _stopTimer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(20),
          child: Image.asset(
            'assets/images/worldwide.gif',
            height: 100,
            width: 100,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateLocation,
        child: Icon(Icons.location_on),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isTimerRunning) {
                    _stopTimer();
                  } else {
                    _startTimer();
                  }
                  isTimerRunning = !isTimerRunning;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  isTimerRunning ? Colors.red : Colors.green,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isTimerRunning ? 'Stop' : 'Start',
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
    );
  }
}
