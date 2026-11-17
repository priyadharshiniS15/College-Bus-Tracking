import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(nearbyhos());
}


class nearbyhos extends StatefulWidget {
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
  final String option;
  final String status;







  da(this.cname, this.date,this.caddress,this.cmobile,this.clocation,
      this.ngoname, this.cnkey,this.nkey,this.nmobile,this.nlocation,this.members,
      this.ckey,this.naddress,this.option,this.status

      );



}






class _MyHomePageState extends State<nearbyhos> {

  String authh = " ";

  var islogoutloading = false;


  final DatabaseReference _databaseReference =

  FirebaseDatabase.instance.reference().child('nearbyhospital');
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
        title: Text('Near BY Hospital'),

      ), body:


    _buildListViewWithDivider(),

    );
  }

  Widget _buildListViewWithDivider() {
    return StreamBuilder(
      stream: _databaseReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
          Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          List<String> itemIds = data.keys.toList();

          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF87CEEB), // Light Sky Blue
                    Color(0xFF4682B4), // Steel Blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.only(top: 180),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF87CEEB), // Light Sky Blue
                        Color(0xFF4682B4), // Steel Blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: itemIds.map((itemId) {
                        String hosname =
                            data[itemId]['hosname']?.toString() ?? '';
                        String address =
                            data[itemId]['address']?.toString() ?? '';
                        String mobile = data[itemId]['mobile']?.toString() ??
                            '';
                        String location =
                            data[itemId]['location']?.toString() ?? '';

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        hosname,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 28,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                      Text(
                                        address,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        mobile,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              height: 2,
                              color: Colors.black.withOpacity(0.5),
                              margin: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}