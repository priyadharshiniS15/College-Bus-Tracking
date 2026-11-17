/*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';





void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(thi());
}

class thi extends StatefulWidget {

  const thi({super.key});
  @override
  State<thi> createState() => _usrequState();
}


class da{
  final String cname;
  final String caddress;
  final String cmobile;
  final String clocation;
  final String ckey;
  final String cnkey;
  final String date;
  final String members;
  final String naddress;
  final String ngoname;
  final String nkey;
  final String nmobile;
  final String nlocation;









  da(this.cname, this.date,this.caddress,this.cmobile,this.clocation,
      this.ngoname, this.cnkey,this.nkey,this.nmobile,this.nlocation,this.members,
      this.ckey,this.naddress

      );



}






class _usrequState extends State<thi> {

  String authh = " ";

  final DatabaseReference _databaseReference =

  FirebaseDatabase.instance.reference().child('Lateform');
  List<da> dataList = [];

  @override
  void initState() {
    super.initState();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;

    if (userId != null) {
      setState(() {
        authh = userId;
      });

      // Construct the path in the Realtime Database using the userId


      // Fetch data from the Realtime Database


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,




      ),
      body: _buildListViewWithDivider(),

    );
  }

  Widget _buildListViewWithDivider() {
    return StreamBuilder(
      stream: _databaseReference
          .orderByChild('status1')
          .equalTo('request')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
          Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          List<String> itemIds = data.keys

              .toList();

          // Check if the list is empty
          if (itemIds.isEmpty) {
            return Center(
              child: Text('No requests available.'),
            );
          }

          return ListView.builder(
            itemCount: itemIds.length * 2 - 1, // Add dividers
            itemBuilder: (context, index) {
              if (index.isOdd) {
                // Divider
                return Divider();
              } else {
                // Item
                int itemIndex = index ~/ 2;
                String itemId = itemIds[itemIndex];
                String pname = data[itemId]['pname']?.toString() ?? '';
                String category = data[itemId]['category']?.toString() ?? '';
                String date = data[itemId]['date']?.toString() ?? '';
                String location = data[itemId]['location']?.toString() ?? '';
                String address = data[itemId]['address']?.toString() ?? '';
                String des = data[itemId]['des']?.toString() ?? '';
                String mobile = data[itemId]['mobile']?.toString() ?? '';
                String time = data[itemId]['time']?.toString() ?? '';
                return Card(
                  elevation: 5,
               color: Colors.purple[100],
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],  // Choose your desired background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(date, style: TextStyle(color: Colors.black45,fontSize: 23)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('Bus number: $des',style: TextStyle(color: Colors.white,fontSize: 15)),

                          Text('From location: $address',style: TextStyle(color: Colors.white,fontSize: 15)),



                    Text('To location: $location',style: TextStyle(color: Colors.white,fontSize: 15)),


                    Text('Late time: $mobile',style: TextStyle(color: Colors.white,fontSize: 15)),


                  Text('Update date: $date',style: TextStyle(color: Colors.white,fontSize: 15)),


              Text('Update time: $time',style: TextStyle(color: Colors.white,fontSize: 15)),


              ],
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        // child: Image.asset(
                        //   'assets/images/contacts.png',
                        //   width: 60,
                        //   height: 60,
                        //   fit: BoxFit.cover,
                        // ),
                      ),

                    ),
                  ),
                );
              }
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // Handle error or no data case
          return Center(
            child: Text('No Requests Available.'),
          );
        }
      },
    );
  }
}*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(thi());
}

class thi extends StatefulWidget {
  const thi({super.key});
  @override
  State<thi> createState() => _usrequState();
}

class da {
  final String cname;
  final String caddress;
  final String cmobile;
  final String clocation;
  final String ckey;
  final String cnkey;
  final String date;
  final String members;
  final String naddress;
  final String ngoname;
  final String nkey;
  final String nmobile;
  final String nlocation;

  da(this.cname, this.date, this.caddress, this.cmobile, this.clocation,
      this.ngoname, this.cnkey, this.nkey, this.nmobile, this.nlocation,
      this.members, this.ckey, this.naddress);
}

class _usrequState extends State<thi> {
  String authh = " ";
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('Lateform');
  List<da> dataList = [];

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;

    if (userId != null) {
      setState(() {
        authh = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bus Late Informations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F0FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildListViewWithDivider(),
      ),
    );
  }

  Widget _buildListViewWithDivider() {
    return StreamBuilder(
      stream: _databaseReference
          .orderByChild('status1')
          .equalTo('request')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
          Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          List<String> itemIds = data.keys.toList();

          if (itemIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_bus, size: 60, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No Late Requests',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'All buses are on time!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: itemIds.length * 2 - 1,
            itemBuilder: (context, index) {
              if (index.isOdd) {
                return Divider(height: 1, color: Colors.grey[300]);
              } else {
                int itemIndex = index ~/ 2;
                String itemId = itemIds[itemIndex];
                String busnumber = data[itemId]['busnumber']?.toString() ?? '';
                String busname = data[itemId]['busname']?.toString() ?? '';
                String drivername = data[itemId]['drivername']?.toString() ?? '';
                String category = data[itemId]['category']?.toString() ?? '';
                String reason = data[itemId]['reason']?.toString() ?? '';
                String date = data[itemId]['date']?.toString() ?? '';
                String location = data[itemId]['location']?.toString() ?? '';
                String address = data[itemId]['address']?.toString() ?? '';
                String des = data[itemId]['des']?.toString() ?? '';
                String mobile = data[itemId]['mobile']?.toString() ?? '';
                String time = data[itemId]['time']?.toString() ?? '';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2575FC).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.directions_bus,
                                  color: Color(0xFF2575FC),
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  '$busname - $busnumber',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2575FC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          /*_buildInfoRow(Icons.confirmation_number, 'Bus number:', busnumber),*/
                          _buildInfoRow(Icons.location_on, 'Driver Name:', drivername),
                          _buildInfoRow(Icons.location_on, 'Location:', location),
                          _buildInfoRow(Icons.location_on, 'Route:', category),
                          _buildInfoRow(Icons.location_on, 'Reason:', reason),
                          _buildInfoRow(Icons.access_time, 'Late time:', mobile),
                          _buildInfoRow(Icons.calendar_today, 'Update date:', date),
                          _buildInfoRow(Icons.schedule, 'Update time:', time),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2575FC)),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading Requests...',
                  style: TextStyle(
                    color: Color(0xFF2575FC),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'No Requests Available',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Color(0xFF6A11CB)),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: '$label ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}