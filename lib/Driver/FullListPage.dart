
// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class FullListPage extends StatefulWidget {
  final String pname;
  final String date;
  final String location;
  final String address;
  final String des;
  final String pkey;
  final String udkey;
  final String mobile;
  final String status1;
  final String status2;
  final String time;
  final String hosname;
  final String ambnumber;
  final String aaddress;

  final String amobile;

  final String akey;

  FullListPage({
    required this.pname,
    required this.date,
    required this.location,
    required this.des,
    required this.address,
    required this.pkey,
    required this.udkey,
    required this.mobile,
    required this.status1,
    required this.status2,
    required this.time,
    required this.hosname,
    required this.ambnumber,
    required this.aaddress,
    required this.amobile,
    required this.akey,


  });

  @override
  _FullListPageState createState() => _FullListPageState();
}

class _FullListPageState extends State<FullListPage> {
  String selectedRadio = ''; // Variable to hold the selected radio value
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();


  DatabaseReference reference = FirebaseDatabase.instance.reference();


  void fetchData() async {
    User? user = _auth.currentUser;
    String? userId = user?.uid;

    try {
      // Assuming `userId` is not null (you might want to check this before entering the try block)
      String dataKey = _database
          .child('Accept')
          .push()
          .key!;

      await _database.child('Accept').child(widget.udkey).set({
        'pname': widget.pname,
        'mobile': widget.date,
        'address': widget.location,
        'location': widget.address,
        'udkey': widget.udkey,
        'des': widget.des,
        'date': widget.date,
        'mobile': widget.mobile,
        'pkey': widget.pkey,
        'status1': 'accept',
        'status2': widget.status2,
        'time': widget.time,
        'hosname': widget.hosname,
        'ambnumber': widget.ambnumber,
        'amobile': widget.amobile,
        'aaddress': widget.aaddress,
        'akey': widget.akey,


      });
print(widget.udkey);
      DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child("Application").child(widget.udkey);

      // Replace "your_key" with the key you want to update
      String keyToUpdate = "status1";

      // Replace "new_value" with the new value you want to set
      String newValue = "accept";

      // Create a map with the key-value pair you want to update
      Map<String, dynamic> updateData = {keyToUpdate: newValue};

      // Use the update method to update the specific key-value pair
      databaseReference.update(updateData).then((_) {
        print("Update successful!");
      }).catchError((error) {
        print("Failed to update: $error");
      });












      //
// // Creating a reference to the specific child node using its key
//       DatabaseReference childReference = reference.child(widget.udkey);
//
// // Using remove method on the specific child node
//       childReference.remove().then((_) {
//         print("Data with key ${widget.udkey} deleted successfully!");
//       });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.green),
              SizedBox(width: 8.0),
              Text('Accepted!'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
        ),
      );



      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ambboard(email: widget.location,  name: widget.hosname, driverid:widget.ambnumber,
              mobile:widget.mobile,ukey:widget.akey))
      );







    } catch (error) {
      print("Error saving data: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 1, // You have only one item in the list
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Patient name: ${widget.pname}'),
                        Text('Address: ${widget.address}'),
                        Text('Location: ${widget.location}'),
                        Text('Description: ${widget.des}'),
                        Text('Mobile number: ${widget.mobile}'),
                        // Add other fields as needed
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add the functionality you want when the "Accept" button is pressed
                    // For example, you can navigate to another screen or perform an action.
                    fetchData();
                  },
                  child: Text('Accept'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}