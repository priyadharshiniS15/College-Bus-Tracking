import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Admin/admin.dart';
import '../Admin/adminhome.dart';

class AuthGate3 extends StatelessWidget {
  const AuthGate3({super.key});

  Future<bool> isAdmin(User user) async {
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("Admin/${user.uid}");

    DatabaseEvent event = await ref.once();

    if (event.snapshot.value == null) return false;

    final raw = event.snapshot.value as Map;
    final data = raw.map((k, v) => MapEntry(k.toString(), v));

    return data["role"] == "admin";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return AdminLogin();
        }

        User user = snapshot.data!;

        return FutureBuilder(
          future: isAdmin(user),
          builder: (context, snap) {
            if (!snap.hasData) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snap.data == true) {
              return AdminHomePage(); // SUCCESS
            } else {
              FirebaseAuth.instance.signOut();
              return AdminLogin();
            }
          },
        );
      },
    );
  }
}
