
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'FullListPage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(usrequ());
}

class usrequ extends StatefulWidget {
  final String? ambnumber;
  final String? hosname;
  final String? mobile;
  final String? ukey;

  final String? email;
  const usrequ({super.key,this.email,this.hosname,this.ambnumber,this.mobile,this.ukey});
  @override
  State<usrequ> createState() => _usrequState();
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






class _usrequState extends State<usrequ> {

  String authh = " ";

  final DatabaseReference _databaseReference =

  FirebaseDatabase.instance.reference().child('Application');
  List<da> dataList = [];

  @override
  void initState() {
    super.initState();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;
    print('Email from widget: ${widget.email}');
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

        title: Text('Requests'),


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
              .where((itemId) => data[itemId]['location'] == widget.email)
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
                String address = data[itemId]['address']?.toString() ?? '';
                String date = data[itemId]['date']?.toString() ?? '';
                String des = data[itemId]['des']?.toString() ?? '';
                String location = data[itemId]['location']?.toString() ?? '';
                String mobile = data[itemId]['mobile']?.toString() ?? '';
                String pkey = data[itemId]['pkey']?.toString() ?? '';
                String pname = data[itemId]['pname']?.toString() ?? '';
                String status1 = data[itemId]['status1']?.toString() ?? '';
                String status2 = data[itemId]['status2']?.toString() ?? '';
                String time = data[itemId]['time']?.toString() ?? '';
                String udkey = data[itemId]['udkey']?.toString() ?? '';

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(pname),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: $date'),
                          Text('Time: $time'),
                        ],
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          'assets/images/contacts.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullListPage(
                                    pname: pname,
                                    address: address,
                                    date: date,
                                    des: des,
                                    location: location,
                                    pkey: pkey,
                                    udkey: udkey,
                                    mobile: mobile,
                                    status1: status1,
                                    status2: status2,
                                    time: time,
                                    aaddress: widget.email ?? "",
                                    hosname: widget.hosname ?? "",
                                    ambnumber: widget.ambnumber ?? "",
                                    amobile: widget.mobile ?? "",
                                    akey: widget.ukey ?? "",
                                  ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
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
}