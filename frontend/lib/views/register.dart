import 'package:flutter/material.dart';
import 'package:mobile_frontend/utils/navigator.dart';
import 'package:mobile_frontend/widget/customButton.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/validator.dart';
import '../widget/fieldbox.dart';
import 'package:mobile_frontend/services/api_service.dart';
import 'package:mobile_frontend/utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      print('Attempting registration...'); // Debug log
      final response = await _apiService.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('Registration response: $response'); // Debug log

      if (response['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? 'Registration successful')),
        );
        Navigator.pop(context); // Go back to login page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['error'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Registration error: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Text('Register New Patient'),
        backgroundColor: AppColors.lightGrey,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                FieldBox(
                  label: 'Name',
                  controller: _nameController,
                  validator: Validator.validateText,
                  onChanged: (value) {},
                  textCapitalization: TextCapitalization.words,
                ),
                SizedBox(height: 20),
                FieldBox(
                  label: 'Email',
                  controller: _emailController,
                  validator: Validator.validateEmailAddress,
                  onChanged: (value) {},
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                FieldBox(
                  label: 'Password',
                  controller: _passwordController,
                  validator: Validator.validatePassword,
                  obscureText: true,
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),
                FieldBox(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  obscureText: true,
                  onChanged: (value) {},
                ),
                SizedBox(height: 40),
                _isLoading
                    ? CircularProgressIndicator()
                    : SubmitButton(
                        onPressed: _register,
                        text: 'Register',
                        color: AppColors.turquoise,
                      ),
                SizedBox(height: 20),
                NextButton(
                  valueColor: 0xFF00ADB5,
                  routeName: '/login',
                  nameButton: 'Back to Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
