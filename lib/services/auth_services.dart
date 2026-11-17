import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Students/dashboard.dart';
import '../Students/userlogin.dart';



class AuthService {
  Future<void> createUser(Map<String, dynamic> data, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email']!,
        password: data['password']!,
      );

      DatabaseReference _database = FirebaseDatabase.instance.reference();
      User? user = FirebaseAuth.instance.currentUser;
      String? userId = user?.uid;

      if (userId != null) {
        await _database.child('Student').child(userId).set({
          'email': data['email'],
          'password': data['password'],
          'location':data['location'],
          'rollno': data['rollno'],
          'idno': data['idno'],
          'year': data['year'],
          'department': data['department'],
          'name':data['name'],
          'ukey': userId,
          'role': 'student',

        });

        await sendVerificationEmail();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered Successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLogin()),
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

  Future<void> userLogin(String email, String password, BuildContext context) async {
    try {

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;


      DatabaseReference ref = FirebaseDatabase.instance.ref("Student/$uid");
      DatabaseEvent event = await ref.once();

      final raw = event.snapshot.value as Map<dynamic, dynamic>?;

      if (raw == null) {
        FirebaseAuth.instance.signOut();
        showError(context, "Student data not found.");
        return;
      }


      Map<String, dynamic> userData =
      raw.map((key, value) => MapEntry(key.toString(), value));

      print("Student Data: $userData");
      print("Role: ${userData['role']}");
      print("Status: ${userData['status']}");

      if (userData["role"] != "student") {
        FirebaseAuth.instance.signOut();
        showError(context, "Your account is not a student account.");
        return;
      }


      if (userData["status"] != "approved") {
        FirebaseAuth.instance.signOut();
        showError(context, "Your account is waiting for admin approval.");
        return;
      }


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => userboard(
            // pass student details if needed
        /*    name: userData["name"],
            rollno: userData["rollno"],
            mobile: userData["mobile"],
            course: userData["course"],
            ukey: userData["ukey"],*/
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

