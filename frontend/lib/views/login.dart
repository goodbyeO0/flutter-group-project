import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_frontend/utils/navigator.dart';
import 'package:mobile_frontend/widget/customButton.dart';
import 'package:mobile_frontend/widget/fieldbox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/validator.dart';
import 'package:mobile_frontend/services/api_service.dart';
import 'package:mobile_frontend/views/home.dart';
import 'package:mobile_frontend/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        if (response['status'] == 200) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Login successful')),
          );

          // Navigate to home screen with user data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                userData: response['data'],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Login failed')),
          );
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        print('Login error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 50),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkNavy,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.charcoal.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        size: 80,
                        color: AppColors.turquoise,
                      ),
                      Text(
                        "Hospital Tracker",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
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
                SizedBox(height: 40),
                _isLoading
                    ? CircularProgressIndicator()
                    : SubmitButton(
                        onPressed: _login,
                        text: 'Login',
                        color: AppColors.turquoise,
                      ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: NextButton(
                    valueColor: 0xFF00ADB5,
                    routeName: '/register',
                    nameButton: 'Register',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
