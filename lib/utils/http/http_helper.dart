import 'dart:convert';

import 'package:http/http.dart' as http;
class OHttpHelper{
  static const String _baseUrl='https://your-api-base-url.com';

  static Future<Map<String,dynamic>> get(String endpoint)async{
    final response=await http.get(Uri.parse('$_baseUrl/$endpoint'));
  return _handleResponse(response);
  }
  static Future<Map<String,dynamic>> post(String endpoint,dynamic data)async{
    final response=await http.post(Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type':'application/json'},
      body: json.encode(data)
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    // Implement your response handling logic here
    // For example, you can check the status code and parse the JSON response
    if (response.statusCode == 200) {
      return json.decode(response.body);
      return {'data': response.body};
    } else {
      // Handle error
      throw Exception('Failed to load data ${response.statusCode}');
    }
  }



}