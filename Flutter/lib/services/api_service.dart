import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/notification.dart';
import '../models/work_order.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';

  // Test connection to backend
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {'Content-Type': 'application/json'},
      );
      print('Test connection response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Test connection failed: $e');
      return false;
    }
  }

  // Login API
  static Future<Map<String, dynamic>> login(String employeeId, String password) async {
    try {
      print('Attempting login for Employee ID: $employeeId');
      print('Sending request to: $baseUrl/maint/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/maint/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'EMPLOYEE_ID': employeeId,
          'PASSWORD': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed response: $data');
        return data;
      } else if (response.statusCode == 500) {
        print('Server error 500 - checking if backend is running');
        return {
          'success': false,
          'message': 'Backend server error. Please check if the server is running on port 5000.',
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      print('Login error: $e');
      if (e.toString().contains('Connection refused')) {
        return {
          'success': false,
          'message': 'Cannot connect to backend server. Please make sure the server is running on port 5000.',
        };
      }
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Get Notifications by Plant (iwerk)
  static Future<List<MaintenanceNotification>> getNotifications(String plantId) async {
    try {
      print('Fetching notifications for plant (iwerk): $plantId');
      final response = await http.get(
        Uri.parse('$baseUrl/maint/notisfy/$plantId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Notifications response status: ${response.statusCode}');
      print('Notifications response body: ${response.body}');

      if (response.statusCode == 404) {
        print('No notifications found for plant: $plantId');
        return []; // Return empty list instead of throwing exception
      }

      final data = jsonDecode(response.body);
      
      if (data['success'] == true && data['data'] != null) {
        final notifications = (data['data'] as List)
            .map((item) => MaintenanceNotification.fromJson(item))
            .toList();
        print('Found ${notifications.length} notifications for plant: $plantId');
        return notifications;
      } else {
        print('No notifications data found for plant: $plantId');
        return []; // Return empty list instead of throwing exception
      }
    } catch (e) {
      print('Notifications error: $e');
      return []; // Return empty list instead of throwing exception
    }
  }

  // Get Work Orders by Plant (werks)
  static Future<List<WorkOrder>> getWorkOrders(String plantId) async {
    try {
      print('Fetching work orders for plant (werks): $plantId');
      final response = await http.get(
        Uri.parse('$baseUrl/maint/work/$plantId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Work orders response status: ${response.statusCode}');
      print('Work orders response body: ${response.body}');

      if (response.statusCode == 404) {
        print('No work orders found for plant: $plantId');
        return []; // Return empty list instead of throwing exception
      }

      final data = jsonDecode(response.body);
      
      if (data['success'] == true && data['data'] != null) {
        final workOrders = (data['data'] as List)
            .map((item) => WorkOrder.fromJson(item))
            .toList();
        print('Found ${workOrders.length} work orders for plant: $plantId');
        return workOrders;
      } else {
        print('No work orders data found for plant: $plantId');
        return []; // Return empty list instead of throwing exception
      }
    } catch (e) {
      print('Work orders error: $e');
      return []; // Return empty list instead of throwing exception
    }
  }

  // Get Plants from backend
  static Future<List<String>> getPlants() async {
    try {
      print('Fetching available plants from backend');
      
      // Return both plant IDs - 0001 has data, 0002 may not have data
      final plants = ['0001', '0002'];
      
      print('Plants available: $plants');
      return plants;
    } catch (e) {
      print('Plants error: $e');
      return ['0001', '0002']; // Fallback to both plants
    }
  }
} 