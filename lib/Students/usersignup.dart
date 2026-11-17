import 'package:collegebustracking/Students/userlogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../services/auth_services.dart';
import '../utills/appvalidator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: usersignup(),
  ));
}

class usersignup extends StatefulWidget {
  usersignup({super.key});

  @override
  State<usersignup> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<usersignup> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _usernamecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final locacontroller = TextEditingController();
  final rollno = TextEditingController();
  final idno = TextEditingController();
  final Year = TextEditingController();
  final Department = TextEditingController();
  final _passwordcontroller = TextEditingController();
  var isLoader = false;
  var authservice = AuthService();

  Future<void> _submitform() async {
    setState(() {
      isLoader = true;
    });

    var data = {
      "email": _emailcontroller.text,
      "password": _passwordcontroller.text,
      "name": _usernamecontroller.text,
      "rollno": rollno.text,
      "idno": idno.text,
      "year": Year.text,
      "department": Department.text,
      "location": locacontroller.text,
    };
    await authservice.createUser(data, context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserLogin(),
      ),
    );

    setState(() {
      isLoader = false;
    });
  }

  var appvalidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Modern gradient background with light animation
          AnimatedContainer(
            duration: Duration(seconds: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6A11CB),
                  Color(0xFF2575FC),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative elements
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    _buildHeader(),
                    SizedBox(height: 40),

                    // Form section
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          // Name field
                          _buildModernInputField(
                            controller: _usernamecontroller,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                            validator: appvalidator.validatepassword,
                          ),
                          SizedBox(height: 16),

                          // Email field
                          _buildModernInputField(
                            controller: _emailcontroller,
                            label: 'Email',
                            icon: Icons.email_outlined,
                            validator: appvalidator.validateEmail,
                          ),
                          SizedBox(height: 16),

                          // Roll number field
                          _buildModernInputField(
                            controller: rollno,
                            label: 'Roll Number',
                            icon: Icons.badge_outlined,
                            validator: appvalidator.validatepassword,
                          ),

                          SizedBox(height: 16),

                          // Roll number field
                          _buildModernInputField(
                            controller: idno,
                            label: 'ID Card Number',
                            icon: Icons.badge_outlined,
                            validator: appvalidator.validatepassword,
                          ),
                          SizedBox(height: 16),

                          // Roll number field
                          _buildModernInputField(
                            controller: Year,
                            label: 'Year',
                            icon: Icons.badge_outlined,
                            validator: appvalidator.validatepassword,
                          ),
                          SizedBox(height: 16),

                          // Roll number field
                          _buildModernInputField(
                            controller: Department,
                            label: 'Department',
                            icon: Icons.badge_outlined,
                            validator: appvalidator.validatepassword,
                          ),
                          SizedBox(height: 16),

                          // Password field
                          _buildModernInputField(
                            controller: _passwordcontroller,
                            label: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: true,
                            validator: appvalidator.validatepassword,
                          ),
                          SizedBox(height: 16),

                          // Location field
                          _buildModernInputField(
                            controller: locacontroller,
                            label: 'Current Location',
                            icon: Icons.location_on_outlined,
                            validator: appvalidator.validatepassword,
                          ),
                          SizedBox(height: 32),

                          // Sign up button
                          _buildSignUpButton(),
                          SizedBox(height: 24),

                          // Login link
                          _buildLoginLink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Create Account',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Join our college community today',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildModernInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black87, fontSize: 16),
        cursorColor: Color(0xFF2575FC),
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF2575FC), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          isLoader ? print("Loading") : _submitform();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Color(0xFF2575FC),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: isLoader
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Color(0xFF2575FC),
            strokeWidth: 3,
          ),
        )
            : Text(
          'SIGN UP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserLogin()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: 'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}