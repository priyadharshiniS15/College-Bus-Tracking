import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
import '../services/DriverAuthservice.dart';
import '../utills/appvalidator.dart';
import 'driverlogin.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: SignUpView(),
  ));
}

class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController hospicontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController ambnumber = TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();

  var isLoader = false;
  var authservice = DriverAuthService();
  var appvalidator = AppValidator();

  Future<void> _submitForm() async {
    setState(() {
      isLoader = true;
    });

    var data = {
      "dname": hospicontroller.text,
      "email": _emailcontroller.text,
      "password": _passwordcontroller.text,
      "mobile": _phonecontroller.text,
      "address": addresscontroller.text,
      "did": ambnumber.text,
    };

    await authservice.createUserDrivers(data, context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );

    setState(() {
      isLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
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
                    Text(
                      'Create New Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _buildTextField(
                      controller: hospicontroller,
                      label: 'Driver Name',
                      icon: Icons.local_hospital,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      controller: ambnumber,
                      label: 'Driver ID',
                      icon: Icons.emergency_share,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      controller: addresscontroller,
                      label: 'Location',
                      icon: Icons.location_on,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      controller: _emailcontroller,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: appvalidator.validateEmail,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      controller: _phonecontroller,
                      label: 'Mobile Number',
                      icon: Icons.call,
                      validator: appvalidator.validatemobile,
                    ),
                    SizedBox(height: 16.0),
                    _buildTextField(
                      controller: _passwordcontroller,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: appvalidator.validatepassword,
                    ),
                    SizedBox(height: 30.0),
                    SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          isLoader ? print("Loading") : _submitForm();
                        },
                        child: isLoader
                            ? Center(child: CircularProgressIndicator())
                            : Text('Create', style: TextStyle(fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 245, 89, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => LoginView()));
                        },
                        child: Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.black),
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.blue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: Color(0xFFEEEEEE),
        filled: true,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        suffixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }
}
