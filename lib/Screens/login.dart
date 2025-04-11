import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication package
import 'home_screen.dart'; // Import the HomeScreen
import 'forgotPassword.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        // Sign in with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // If login is successful, navigate to HomeScreen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Login successful! Welcome ${userCredential.user?.email}')),
        );

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login failed. Please try again.';

        if (e.code == 'invalid-credential') {
          errorMessage = 'Please check your email and/or password.';
        } else if (e.code == 'invalid-email') {
          errorMessage =
              'The email address is invalid. Please check the format.';
        } else if (e.code == 'user-not-found') {
          errorMessage =
              'No user found for that email. Please check your email address.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password provided.';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'The user account has been disabled.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  labelStyle:
                      TextStyle(color: isDark ? Colors.white : Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: isDark ? Colors.white : Colors.black),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  labelStyle:
                      TextStyle(color: isDark ? Colors.white : Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: isDark ? Colors.white : Colors.black),
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to ForgotPasswordPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Centering the Login button and adding a shadow
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _login, // Trigger the login method
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            isDark
                                ? Colors.grey[800]
                                : Colors
                                    .white, // Button color (white for light mode)
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            isDark ? Colors.white : Colors.black, // Text color
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black, // Text color
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
