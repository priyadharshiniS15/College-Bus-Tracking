import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Students/dashboard.dart';
import '../Students/userlogin.dart';

void main() {
  runApp(new MaterialApp(
    home: new AuthGate(),



  ));

}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<Map<String, dynamic>?> getDriverData(String uid) async {
    final ref = FirebaseDatabase.instance.ref().child('Student').child(uid);

    final event = await ref.once();            // DatabaseEvent
    final data = event.snapshot.value;         // Correct way

    if (data == null) return null;

    return Map<String, dynamic>.from(data as Map);
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // 🔹 User NOT logged in → go to login view
        if (!snapshot.hasData) {
          return UserLogin();
        }

        String uid = snapshot.data!.uid;

        return FutureBuilder(
          future: getDriverData(uid),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            var data = snap.data!;

            return userboard(

            );
          },
        );
      },
    );
  }
}








