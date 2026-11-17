import 'package:collegebustracking/Admin/studentlist.dart';
import 'package:collegebustracking/Admin/viewdrivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin.dart';
import 'approvedrivers.dart';
import 'approvestudents.dart';
import 'latereports.dart';
import 'package:intl/intl.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool _isLoggingOut = false;
  int _currentIndex = 0;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);

    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminLogin()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed: ${error.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoggingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateFormat('EEEE, MMMM d').format(DateTime.now());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        elevation: 3,
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          _isLoggingOut
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: Colors.white),
          )
              : IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),

      drawer: _buildDrawer(context),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP CARD — WELCOME
              _buildWelcomeCard(currentDate),

              SizedBox(height: 20),

              // TITLE
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              SizedBox(height: 10),

              // GRID BUTTONS
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.95,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildDashboardCard(
                    title: "Approve Drivers",
                    icon: Icons.approval,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => ApproveDrivers()),
                    ),
                  ),
                  _buildDashboardCard(
                    title: "Approve Students",
                    icon: Icons.group_add,
                    color: Colors.deepPurple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => StudentApprovalApp()),
                    ),
                  ),
                  _buildDashboardCard(
                    title: "Driver Management",
                    icon: Icons.person,
                    color: Colors.teal,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => DriverApp()),
                    ),
                  ),
                  _buildDashboardCard(
                    title: "Student Management",
                    icon: Icons.school_rounded,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => StudentApp()),
                    ),
                  ),
                  _buildDashboardCard(
                    title: "Late Bus Reports",
                    icon: Icons.warning_rounded,
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => LateReportsApp()),
                    ),
                  ),
          /*        _buildDashboardCard(
                    title: "Live Bus Tracking",
                    icon: Icons.map_rounded,
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => trackbus()),
                    ),
                  ),*/
             /*     _buildDashboardCard(
                    title: "Attendance",
                    icon: Icons.assignment_turned_in,
                    color: Colors.amber.shade800,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => Attendance()),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),

      // BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Track"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // REUSABLE WIDGETS
  // -------------------------------------------------------------------------

  Widget _buildWelcomeCard(String date) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade800, Colors.indigo.shade500],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Admin!",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 6),
          Text(
            date,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 12),
          Text(
            "Manage students, drivers, buses, and track transportation in real-time. Monitor student travel activity while ensuring every trip is safe and transparent. Easily handle drivers, schedules, and routes through a centralized admin system, improving overall efficiency and communication across the school transportation network.",
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 32, color: color),
            ),
            SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer(context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade700, Colors.indigo.shade500],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings,
                      color: Colors.indigo, size: 34),
                ),
                SizedBox(height: 12),
                Text("Administrator",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text("admin@gmail.com",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          _drawerItem(Icons.dashboard, "Dashboard", () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.person, "Driver Management", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => DriverApp()));
          }),
          _drawerItem(Icons.group, "Student Management", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => StudentApp()));
          }),
         /* _drawerItem(Icons.warning_rounded, "Late Reports", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => LateReportsApp()));
          }),
          _drawerItem(Icons.map, "Live Bus Tracking", () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => trackbus()));
          }),*/
          Divider(),
          _drawerItem(Icons.logout, "Logout", _logout),
        ],
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo.shade700),
      title: Text(title),
      onTap: onTap,
    );
  }
}
