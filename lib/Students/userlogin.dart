import 'package:flutter/material.dart';
import 'package:collegebustracking/Students/usersignup.dart';
import '../main.dart';
import '../services/auth_services.dart';
import '../utills/appvalidator.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _LoginViewState();
}

class _LoginViewState extends State<UserLogin> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authservice = AuthService();
  var appvalidator = AppValidator();
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      await authservice.userLogin(
        data["email"]!,
        data["password"]!,
        context,

      );

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A237E),
                Color(0xFF283593),
                Color(0xFF303F9F),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25),
                      FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Column(
                          children: [
                            Text(
                              'STUDENT LOGIN',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 15,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),


                            SizedBox(height: 5),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),


                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Email Field
                                Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5, bottom: 8),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.school_outlined,
                                              color: Colors.blue[900],
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Email ID',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue[900],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          hintText: 'username@veltech.edu',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w400,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Colors.blue[900]!,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) => appvalidator.validateEmail(value!),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(bottom: 25),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5, bottom: 8),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.lock_outline,
                                              color: Colors.blue[900],
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Password',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue[900],
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                          hintText: 'Enter your password',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w400,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.vpn_key_outlined,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons.visibility_off_outlined,
                                              color: Colors.grey[600],
                                              size: 20,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Colors.blue[900]!,
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                        ),
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) => appvalidator.validatepassword(value!),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue[900],
                                      onPrimary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      shadowColor: Colors.blue[900]!.withOpacity(0.4),
                                    ),
                                    child: isLoader
                                        ? SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                        : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'LOGIN AS STUDENT',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),

                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => usersignup()),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "REGISTER",
                                        style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.blue[900],
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),


                      SizedBox(height: 14),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              'Veltech University',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Student Bus Tracking System',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}