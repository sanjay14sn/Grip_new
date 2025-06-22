import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final Map<String, dynamic>? extra; // 👈 Add this line

  ApiResponse({
    required this.statusCode,
    required this.isSuccess,
    this.data,
    required this.message,
    this.extra, // 👈 Add this
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
          response = await http.post(uri,
              headers: _defaultHeaders(headers),
              body: body != null ? jsonEncode(body) : null);
          break;
        case 'GET':
          response = await http.get(uri, headers: _defaultHeaders(headers));
          break;
        case 'PUT':
          response = await http.put(uri,
              headers: _defaultHeaders(headers),
              body: body != null ? jsonEncode(body) : null);
          break;
        case 'PATCH':
          response = await http.patch(uri,
              headers: _defaultHeaders(headers),
              body: body != null ? jsonEncode(body) : null);
          break;
        case 'DELETE':
          response = await http.delete(uri,
              headers: _defaultHeaders(headers),
              body: body != null ? jsonEncode(body) : null);
          break;
        default:
          return ApiResponse(
              statusCode: 405,
              isSuccess: false,
              message: 'Unsupported HTTP method: $method',
              data: null);
      }

      return _processResponse(response);
    } catch (e) {
      return ApiResponse(
          statusCode: 500, isSuccess: false, message: 'Error: $e', data: null);
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

  /// 🔗 Custom function to fetch chapter details by ID
  static Future<ApiResponse> fetchChapterDetailsById(String chapterId) async {
    final url = '$endPointbaseUrl/api/mobile/chapters/$chapterId';
    return await makeRequest(
      url: url,
      method: 'GET',
    );
  }

  static Future<ApiResponse> submitOneToOneSlip({
    required String toMember,
    required String whereDidYouMeet,
    required String address,
    required String date,
    File? imageFile,
  }) async {
    try {
      final Uri uri = Uri.parse('$endPointbaseUrl/api/mobile/onetoone');

      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['toMember'] = toMember;
      request.fields['whereDidYouMeet'] = whereDidYouMeet;
      request.fields['date'] = date;
      request.fields['address'] = address;

      if (imageFile != null) {
        final multipartFile =
            await http.MultipartFile.fromPath('images', imageFile.path);
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();
      final statusCode = streamedResponse.statusCode;
      final responseData = jsonDecode(responseString);
      final isSuccess = statusCode >= 200 && statusCode < 300;

      return ApiResponse(
        statusCode: statusCode,
        isSuccess: isSuccess,
        data: responseData,
        message: responseData['message'] ?? 'Request completed',
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        message: 'Error submitting One-to-One slip: $e',
        data: null,
      );
    }
  }

  static Future<ApiResponse> registerVisitor(
      Map<String, dynamic> requestBody) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          isSuccess: false,
          data: null,
          message: 'User not authenticated. Please login again.',
        );
      }

      final uri = Uri.parse('$endPointbaseUrl/api/mobile/visitors');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      final statusCode = response.statusCode;
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final bool isSuccess = statusCode >= 200 &&
          statusCode < 300 &&
          responseData['success'] == true;

      return ApiResponse(
        statusCode: statusCode,
        isSuccess: isSuccess,
        data: responseData['data'],
        message: responseData['message'] ?? 'Unknown error',
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Registration failed: $e',
      );
    }
  }

  static Future<ApiResponse> getVisitorsList() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final uri = Uri.parse('$endPointbaseUrl/api/mobile/visitors/list');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final statusCode = response.statusCode;
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final bool isSuccess = statusCode >= 200 && statusCode < 300;

      return ApiResponse(
        statusCode: statusCode,
        isSuccess: isSuccess,
        data: responseData['data'],
        message: responseData['message'] ?? 'Unknown error',
        // 👇 Add this if ApiResponse supports extra metadata
        extra: {
          'total': responseData['pagination']?['total'] ?? 0,
        },
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Failed to fetch visitors: $e',
      );
    }
  }

  static Future<ApiResponse> getOneToOneList() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final uri = Uri.parse('$endPointbaseUrl/api/mobile/onetoone/list');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final statusCode = response.statusCode;
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final bool isSuccess = statusCode >= 200 && statusCode < 300;

      return ApiResponse(
        statusCode: statusCode,
        isSuccess: isSuccess,
        data: responseData['data'],
        message: responseData['message'] ?? 'Unknown error',
        extra: {
          'total': responseData['pagination']?['total'] ?? 0,
        },
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Failed to fetch one-to-one list: $e',
      );
    }
  }
}
