import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'attendance.dart';
import 'driverlogin.dart';
import 'driverhome.dart';
import 'lateform.dart';
import 'live.dart';

void main() {
  runApp(MaterialApp(
    title: 'College Ambulance Tracker',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const ambboard(),
    debugShowCheckedModeBanner: false,
  ));
}

class ambboard extends StatefulWidget {
  final String? email;
  final String? name;
  final String? driverid;
  final String? ukey;
  final String? mobile;
  final String? address;

  const ambboard({
    Key? key,
    this.email,
    this.name,
    this.driverid,
    this.ukey,
    this.mobile,
    this.address,
  }) : super(key: key);

  @override
  State<ambboard> createState() => _AmbulanceDashboardState();
}

class _AmbulanceDashboardState extends State<ambboard> {
  var isLogoutLoading = false;
  int _currentIndex = 0;
  final DateTime _now = DateTime.now();

  List<Widget> getPages() {
    return [
      AmbulanceHome(
        ukey: widget.ukey,
        dname: widget.name,
        did: widget.driverid,
        mobile: widget.mobile,
      ),
      Live(),
      AllocatedDetails(
        ukey: widget.ukey,
        dname: widget.name,
        did: widget.driverid,
        mobile: widget.mobile,
      ),
    ];
  }

  Future<void> logout() async {
    setState(() {
      isLogoutLoading = true;
    });

    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLogoutLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = getPages();
    final formattedDate = DateFormat('EEEE, MMMM d').format(_now);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),

        backgroundColor: Colors.indigo.shade800,
        elevation: 4,
        actions: [

/*          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => latee()),
                );
              },
              icon: const Icon(Icons.report_problem, size: 18),
              label: const Text('Late Form'),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber.shade700,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: logout,
              icon: isLogoutLoading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red.shade600,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.white,
            ],
          ),
        ),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: Colors.indigo.shade800,
            unselectedItemColor: Colors.grey.shade600,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentIndex == 0
                        ? Colors.indigo.shade100
                        : Colors.transparent,
                  ),
                  child: const Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentIndex == 1
                        ? Colors.indigo.shade100
                        : Colors.transparent,
                  ),
                  child: const Icon(Icons.location_on),
                ),
                label: 'Live Tracking',
              ),
             /* BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _currentIndex == 2
                        ? Colors.indigo.shade100
                        : Colors.transparent,
                  ),
                  child: const Icon(Icons.qr_code_scanner),
                ),
                label: 'Attendance',
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo.shade800,
                  Colors.indigo.shade600,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.bus_alert_outlined,
                    size: 30,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.name ?? 'Bus Driver',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
               /* const SizedBox(height: 4),
                Text(
                  widget.email ?? 'Email',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),*/
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.indigo),
            title: const Text('Dashboard'),
            onTap: () {
              setState(() {
                _currentIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.indigo),
            title: const Text('Live Tracking'),
            onTap: () {
              setState(() {
                _currentIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
         /* ListTile(
            leading: const Icon(Icons.qr_code_scanner, color: Colors.indigo),
            title: const Text('Attendance'),
            onTap: () {
              setState(() {
                _currentIndex = 2;
              });
              Navigator.pop(context);
            },
          ),*/
      /*    ListTile(
            leading: const Icon(Icons.report_problem, color: Colors.indigo),
            title: const Text('Late Form'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => latee()),
              );
            },
          ),*/

          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade600),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: logout,
          ),
        ],
      ),
    );
  }
}