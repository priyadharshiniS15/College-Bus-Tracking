import 'package:collegebustracking/utills/auth_gate.dart';
import 'package:collegebustracking/utills/auth_gate2.dart';
import 'package:collegebustracking/utills/auth_gate3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/VeltechCollegeBus.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.directions_bus,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.yellow, Colors.amber],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'VELTECH UNIVERSITY',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Bus Tracking System',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/VeltechCollegeBus.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40),

                    // Header Section
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.yellow, Colors.amber],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.directions_bus,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.yellow, Colors.amber],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'VELTECH BUS TRACKER',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.yellow.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Smart Campus Transportation System',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    // College Info Card
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.yellow.withOpacity(0.2),
                            Colors.amber.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.yellow.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school,
                                color: Colors.yellow,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Veltech University',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Ensuring safe and timely transportation for all our students '
                                'and staff across the campus.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40),

                    // Login Section Title
                    Container(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'SELECT YOUR ROLE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.yellow,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),


                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        _buildRoleCard(
                          context,
                          icon: Icons.drive_eta,
                          title: 'DRIVER',
                          subtitle: 'Update bus location & status',
                          gradientColors: [
                            Color(0xFF2196F3),
                            Color(0xFF1976D2),
                          ],
                          onTap: () => _navigateTo(context, AuthGate2()),
                        ),

                        SizedBox(height: 20),


                        _buildRoleCard(
                          context,
                          icon: Icons.school,
                          title: 'STUDENT',
                          subtitle: 'Track bus & view schedule',
                          gradientColors: [
                            Color(0xFF4CAF50),
                            Color(0xFF388E3C),
                          ],
                          onTap: () => _navigateTo(context, AuthGate()),
                        ),

                        SizedBox(height: 20),


                        _buildRoleCard(
                          context,
                          icon: Icons.admin_panel_settings,
                          title: 'ADMIN',
                          subtitle: 'Manage system & users',
                          gradientColors: [
                            Color(0xFF9C27B0),
                            Color(0xFF7B1FA2),
                          ],
                          onTap: () => _navigateTo(context, AuthGate3()),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    // Footer
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.yellow.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.yellow,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Veltech University',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Smart Campus Transportation',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required List<Color> gradientColors,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              // Text Content - COMPLETELY FIXED
              Expanded(
                child: Container(
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18, // Reduced for safety
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      // Subtitle
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11, // Reduced for safety
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              // Arrow Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}