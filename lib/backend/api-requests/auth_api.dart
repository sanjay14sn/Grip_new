import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// ✅ Safe fallback if env not configured
final String endPointbaseUrl = dotenv.env['API_BASE_URL'] ??
    (() {
      throw Exception('❌ Missing API_BASE_URL in .env file');
    })();

class ApiResponse {
  final int statusCode;
  final bool isSuccess;
  final dynamic data;
  final String message;

  ApiResponse({
    required this.statusCode,
    required this.isSuccess,
    this.data,
    required this.message,
  });
}

class PublicRoutesApiService {
  static Future<ApiResponse> makeRequest({
    required String url,
    required String method,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            uri,
            headers: _defaultHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'GET':
          response = await http.get(
            uri,
            headers: _defaultHeaders(headers),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: _defaultHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PATCH':
          response = await http.patch(
            uri,
            headers: _defaultHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            uri,
            headers: _defaultHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        default:
          return ApiResponse(
            statusCode: 405,
            isSuccess: false,
            message: 'Unsupported HTTP method: $method',
            data: null,
          );
      }

      return _processResponse(response);
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        message: 'Error: $e',
        data: null,
      );
    }
  }

  static Map<String, String> _defaultHeaders(Map<String, String>? custom) {
    return {
      'Content-Type': 'application/json',
      ...?custom,
    };
  }

  static ApiResponse _processResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final bool isSuccess = statusCode >= 200 && statusCode < 300;
    final dynamic data =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;

    return ApiResponse(
      statusCode: statusCode,
      isSuccess: isSuccess,
      data: data,
      message: response.reasonPhrase ?? '',
    );
  }
}

/// 🔒 Auth-related public routes
class PublicRoutesApi {
  static Future<ApiResponse> Login({
    required String mobileNumber,
    required String pin,
  }) async {
    final String apiUrl = '$endPointbaseUrl/api/mobile/member-login';

    final Map<String, dynamic> requestBody = {
      "mobileNumber": mobileNumber,
      "pin":pin,
    };

    return PublicRoutesApiService.makeRequest(
      url: apiUrl,
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
  }
}
