
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(requestus());
}

class requestus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase ListView Builder',
      home: MyHomePageeeg(),
    );
  }
}

class MyHomePageeeg extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
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






class _MyHomePageState extends State<MyHomePageeeg> {

  String authh = " ";

  final DatabaseReference _databaseReference =

  FirebaseDatabase.instance.reference().child('Accept');
  List<da> dataList = [];

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    String? userId = user?.uid;
    authh = userId!;
    print(authh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Text('Accepted List'),


      ),
      body: _buildListViewWithDivider(),

    );
  }

  Widget _buildListViewWithDivider() {
    return StreamBuilder(
      stream: _databaseReference
          .orderByChild('status1')
          .equalTo('accept')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading requests.'),
          );
        } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return Center(
            child: Text('No accepted requests available.'),
          );
        } else {
          Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          List<String> itemIds = data.keys.toList();

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
                String aaddress = data[itemId]['aaddress']?.toString() ?? '';
                String address = data[itemId]['address']?.toString() ?? '';
                String mobile = data[itemId]['mobile']?.toString() ?? '';
                String location = data[itemId]['location']?.toString() ?? '';
                String akey = data[itemId]['akey']?.toString() ?? '';
                String ambnumber = data[itemId]['ambnumber']?.toString() ?? '';
                String amobile = data[itemId]['amobile']?.toString() ?? '';
                String date = data[itemId]['date']?.toString() ?? '';
                String des = data[itemId]['des']?.toString() ?? '';
                String hosname = data[itemId]['hosname']?.toString() ?? '';
                String pkey = data[itemId]['pkey']?.toString() ?? '';
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         amb(
                          //           pname: pname,
                          //           date: date,
                          //           aaddress: aaddress,
                          //           address: address,
                          //           location: location,
                          //           mobile: mobile,
                          //           akey: akey,
                          //           ambnumber: ambnumber,
                          //           amobile: amobile,
                          //           des: des,
                          //           hosname: hosname,
                          //           pkey: pkey,
                          //           status1: status1,
                          //           status2: status2,
                          //           time: time,
                          //           udkey: udkey,
                          //         ),
                          //   ),
                          // );
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
        }
      },
    );
  }
}