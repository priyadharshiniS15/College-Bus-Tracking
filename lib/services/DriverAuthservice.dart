import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Driver/dashboard.dart';
import '../Driver/driverlogin.dart';



class DriverAuthService {
  Future<void> createUserDrivers(Map<String, dynamic> data, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );

      DatabaseReference _database = FirebaseDatabase.instance.reference();
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      if (userId != null) {
        await _database.child('Driver').child(userId).set({
          'email': data['email'],
          'password': data['password'],
          'address': data['address'],
          'driverid': data['did'],
          'mobile': data['mobile'],
          'dname': data['dname'],
          'ukey':userId ,
          'status':'request' ,
          'role': 'driver',

        });

        await sendVerificationEmail();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered Successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign Up Failed"),
            content: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<void> driverLogin(String email, String password, BuildContext context) async {
    try {
      // LOGIN
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // FETCH DATA
      DatabaseReference ref = FirebaseDatabase.instance.ref("Driver/$uid");
      DatabaseEvent event = await ref.once();

      final raw = event.snapshot.value as Map<dynamic, dynamic>?;

      if (raw == null) {
        FirebaseAuth.instance.signOut();
        showError(context, "Driver data not found.");
        return;
      }

      // Convert safely
      Map<String, dynamic> driverData =
      raw.map((key, value) => MapEntry(key.toString(), value));

      print("Driver Data: $driverData");       // DEBUG
      print("Role: ${driverData['role']}");    // DEBUG
      print("Status: ${driverData['status']}");// DEBUG

      // ROLE CHECK
      if (driverData["role"] != "driver") {
        FirebaseAuth.instance.signOut();
        showError(context, "Your account is not a driver account.");
        return;
      }

      // APPROVAL CHECK
      if (driverData["status"] != "approved") {
        FirebaseAuth.instance.signOut();
        showError(context, "Your account is waiting for admin approval.");
        return;
      }

      // SUCCESS → NAVIGATE
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ambboard(
            name: driverData["dname"],
            driverid: driverData["driverid"],
            mobile: driverData["mobile"],
            ukey: driverData["ukey"],
            address: driverData["address"],
          ),
        ),
      );

    } catch (e) {
      showError(context, e.toString());
    }
  }


  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print("Verification email sent to ${user.email}");
    }
  }
  void showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

