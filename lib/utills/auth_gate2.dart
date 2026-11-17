import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Driver/dashboard.dart';
import '../Driver/driverlogin.dart';

void main() {
  runApp(MaterialApp(
    home: AuthGate2(),
  ));
}

class AuthGate2 extends StatelessWidget {
  const AuthGate2({super.key});

  Future<Map<String, dynamic>?> getDriverData(String uid) async {
    final ref = FirebaseDatabase.instance.ref().child('Driver').child(uid);

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
          return LoginView();
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

            return ambboard(
              name: data['dname'],
              driverid: data['driverid'],
              mobile: data['mobile'],
              ukey: data['ukey'],
              address: data['address'],
            );
          },
        );
      },
    );
  }
}
