import 'package:collegebustracking/Students/userapply.dart';
import 'package:collegebustracking/Students/userlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'fgsdfs.dart';

void main() {
  runApp(MaterialApp(
    home: userboard(),
  ));
}

class userboard extends StatefulWidget {
  const userboard({super.key});

  @override
  State<userboard> createState() => _UserBoardState();
}

class _UserBoardState extends State<userboard> {
  var isLogoutLoading = false;

  Future<void> logout() async {
    setState(() {
      isLogoutLoading = true;
    });

    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserLogin()),
    );

    setState(() {
      isLogoutLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back icon
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
          /*  child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => thi()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Color(0xFF2575FC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list_alt, size: 20),
                  SizedBox(width: 5),
                  Text(
                    'Late Informations',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),*/
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Color(0xFF6A11CB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5,
              ),
              icon: isLogoutLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Color(0xFF6A11CB),
                  strokeWidth: 3,
                ),
              )
                  : Icon(Icons.logout, size: 20),
              label: Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE6F0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: UserApply(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2575FC).withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFF2575FC),
              child: IconButton(
                onPressed: () {
                  // Handle center item click
                },
                icon: Image.asset(
                  'assets/images/1.gif',
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}