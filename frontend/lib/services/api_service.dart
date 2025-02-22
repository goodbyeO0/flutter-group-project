import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Base URL for your Node.js backend
  static const String baseUrl =
      'http://192.168.1.142:3000'; // Your actual Wi-Fi IP

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // User Authentication APIs
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/CheckUser').replace(
          queryParameters: {
            'UserEmail': email,
            'UserPassword': password,
          },
        ),
      );

      return json.decode(response.body);
    } catch (e) {
      return {
        'status': 500,
        'error': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print('Making registration request to: $baseUrl/api/RegisterUser');
      final uri = Uri.parse('$baseUrl/api/RegisterUser').replace(
        queryParameters: {
          'UserName': name,
          'UserEmail': email,
          'UserPassword': password,
        },
      );
      print('Request URI: $uri');

      final response = await http.get(uri).timeout(
        const Duration(seconds: 30), // Increased timeout
        onTimeout: () {
          print('Request timed out');
          throw TimeoutException('Registration request timed out');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return json.decode(response.body);
    } catch (e) {
      print('Registration error: $e');
      if (e is TimeoutException) {
        return {
          'status': 408,
          'error':
              'Request timed out. Please check your connection and try again.',
        };
      }
      return {
        'status': 500,
        'error': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> deleteUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/DeleteUser').replace(
          queryParameters: {
            'UserID': userId.toString(),
          },
        ),
      );

      return json.decode(response.body);
    } catch (e) {
      return {
        'status': 500,
        'error': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> editUser({
    required int userId,
    required String name,
    required String email,
    String? password,
  }) async {
    try {
      final queryParams = {
        'UserID': userId.toString(),
        'UserName': name,
        'UserEmail': email,
      };

      if (password != null) {
        queryParams['UserPassword'] = password;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/EditUser').replace(
          queryParameters: queryParams,
        ),
      );

      return json.decode(response.body);
    } catch (e) {
      return {
        'status': 500,
        'error': 'Network error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getUserData(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/api/GetUserData').replace(
        queryParameters: {
          'UserID': userId.toString(),
        },
      );

      print('Requesting URL: $url'); // Debug print

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'status': response.statusCode,
          'error': 'Server error: ${response.body}',
        };
      }
    } catch (e) {
      print('Error in getUserData: $e');
      return {
        'status': 500,
        'error': 'Network error: $e',
      };
    }
  }

  Future<List<Map<String, dynamic>>> getAllLocations() async {
    try {
      print('Fetching all locations...');
      final response = await http
          .get(
        Uri.parse('$baseUrl/api/ViewAllLocation'),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> registerLocation({
    required String name,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/RegisterLocation').replace(
          queryParameters: {
            'HospitalName': name,
            'HospitalLang': latitude.toString(),
            'HospitalLong': longitude.toString(),
            'HospitalAddress': address,
          },
        ),
      );

      return json.decode(response.body);
    } catch (e) {
      return {
        'status': 500,
        'error': 'Network error: $e',
      };
    }
  }

  Future<List<Map<String, dynamic>>> getNearbyHospitals(
      double lat, double lng) async {
    try {
      print('Fetching nearby hospitals...');
      final response = await http.get(
        Uri.parse('$baseUrl/api/getNearbyHospitals').replace(
          queryParameters: {
            'latitude': lat.toString(),
            'longitude': lng.toString(),
            'radius': '5000', // 5km radius
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load nearby hospitals');
      }
    } catch (e) {
      print('Error fetching nearby hospitals: $e');
      return [];
    }
  }

  Future<String> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return 'Android ${androidInfo.version.release} - ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return '${iosInfo.systemName} ${iosInfo.systemVersion} - ${iosInfo.model}';
      }
      return 'Unknown Device';
    } catch (e) {
      return 'Error getting device info';
    }
  }

  Future<void> trackLocation({
    required int userId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final deviceInfo = await _getDeviceInfo();
      final response = await http.post(
        Uri.parse('$baseUrl/api/trackLocation').replace(
          queryParameters: {
            'UserID': userId.toString(),
            'latitude': latitude.toString(),
            'longitude': longitude.toString(),
            'address': address,
            'deviceInfo': deviceInfo,
          },
        ),
      );

      if (response.statusCode != 200) {
        print('Failed to track location: ${response.body}');
      }
    } catch (e) {
      print('Error tracking location: $e');
    }
  }
}
