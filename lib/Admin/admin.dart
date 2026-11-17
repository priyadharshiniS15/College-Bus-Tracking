import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../utills/auth_gate3.dart';
import 'adminhome.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthGate3()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Login failed"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Title Section
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/campus.gif',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Management Portal',
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to manage college administration',
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),


                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Institutional Email',
                                  prefixIcon: Icon(Icons.school_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please enter a valid college email';
                                  }
                                  return null;
                                },
                                onChanged: (value) => _email = value,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                ),
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return 'Password must be 6+ characters';
                                  }
                                  return null;
                                },
                                onChanged: (value) => _password = value,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 50,
                                child: _isLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                  onPressed: _loginAdmin,
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.indigo,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                            ],
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
    );
  }
}