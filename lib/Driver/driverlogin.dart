import 'package:flutter/material.dart';
import '../main.dart';
import '../services/DriverAuthservice.dart';
import '../utills/appvalidator.dart';
import 'driversignup.dart';

void main() {
  runApp(MaterialApp(
    home: LoginView(),
  ));
}

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authService = DriverAuthService();
  var appValidator = AppValidator();

  Future<void> _submitForm() async {
    setState(() {
      isLoader = true;
    });

    var data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    await authService.driverLogin(
      data["email"]!,
      data["password"]!,
      context,
    );


    setState(() {
      isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false; // Prevent default pop
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF252634),
        ),
        backgroundColor: Color(0xFF252634),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Driver Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          width: 60.0, // same as diameter of CircleAvatar (2 * 70)
                          height: 160.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/1.gif'),
                              fit: BoxFit.cover,
                            ),

                          ),
                        ),

                        SizedBox(height: 30.0),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email,
                          validator: appValidator.validateEmail,
                        ),
                        SizedBox(height: 16.0),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: appValidator.validatepassword,
                        ),
                        SizedBox(height: 40.0),
                        SizedBox(
                          height: 50.0,
                          child: ElevatedButton(
                            onPressed: () {
                              isLoader ? print("Loading") : _submitForm();
                            },
                            child: isLoader
                                ? Center(child: CircularProgressIndicator())
                                : Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 245, 89, 0),
                              onPrimary: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpView(),
                                ),
                              );
                            },
                            child: Text(
                              'Create new account',
                              style: TextStyle(
                                color: Color.fromARGB(255, 245, 89, 0),
                                fontSize: 18,
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.blue,
      keyboardType: TextInputType.emailAddress,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: Color(0xFF494A59),
        filled: true,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        suffixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Color(0x35949494)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      validator: validator,
    );
  }
}
