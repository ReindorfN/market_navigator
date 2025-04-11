import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:market_navigator/Screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String email;
  final String? role;

  const PersonalInfoScreen({
    super.key,
    required this.email,
    this.role,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _saveUserToFirestore(Map<String, dynamic> formData) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      print("ERROR: No current user found. User is not authenticated.");
      throw Exception("You must be logged in to complete registration");
    }

    print("Saving data for user: $uid");
    print("Form data: $formData");

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': widget.email,
        'role': widget.role ?? 'unknown',
        'firstName': formData['firstName'],
        'lastName': formData['lastName'],
        'phoneNumber': formData['phone'],
        'dateOfBirth': formData['dateOfBirth']?.toIso8601String(),
        'createdAt': Timestamp.now(),
      });
      print("User data saved successfully to Firestore!");
    } catch (e) {
      print("Firestore error: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'firstName',
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(2),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'lastName',
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(2),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'phone',
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'dateOfBirth',
                decoration: const InputDecoration(
                  labelText: 'Date of birth',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                inputType: InputType.date,
                format: DateFormat('dd/MM/yyyy'),
                initialValue: _selectedDate,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
                onChanged: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.grey[850]
                        : Colors
                            .white, // Grey for dark mode, white for light mode
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : Colors
                            .black, // White text in dark mode, black text in light mode
                    elevation: isDarkMode
                        ? 0
                        : 5, // No shadow in dark mode, shadow in light mode
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          print("Complete Signup button pressed");
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            print("Form validation successful");
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              final formData = _formKey.currentState!.value;
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              if (currentUser == null) {
                                print("User is not authenticated.");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'You must be logged in to complete registration'),
                                  ),
                                );
                                return;
                              }

                              await _saveUserToFirestore(formData);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Account created successfully!'),
                                ),
                              );

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            } catch (e) {
                              print("Error in signup completion: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            print("Form validation failed");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please complete all required fields correctly'),
                              ),
                            );
                          }
                        },
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        )
                      : const Text(
                          'Complete Signup',
                          style: TextStyle(
                            fontSize: 16,
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
