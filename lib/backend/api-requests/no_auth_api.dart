import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
          response = await http
              .post(uri,
                  headers: _defaultHeaders(headers),
                  body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 12));
          break;
        case 'GET':
          response = await http
              .get(uri, headers: _defaultHeaders(headers))
              .timeout(const Duration(seconds: 12));
          break;
        case 'PUT':
          response = await http
              .put(uri,
                  headers: _defaultHeaders(headers),
                  body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 12));
          break;
        case 'PATCH':
          response = await http
              .patch(uri,
                  headers: _defaultHeaders(headers),
                  body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 12));
          break;
        case 'DELETE':
          response = await http
              .delete(uri,
                  headers: _defaultHeaders(headers),
                  body: body != null ? jsonEncode(body) : null)
              .timeout(const Duration(seconds: 12));
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
    } on TimeoutException catch (_) {
      return ApiResponse(
        statusCode: 408,
        isSuccess: false,
        message: '⏱️ Request timed out. Please try again.',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        message: '⚠️ Unexpected error: $e',
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

  static Future<ApiResponse> submitReferralSlip({
    required String toMember,
    required String referalStatus,
    required Map<String, dynamic> referalDetail,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          isSuccess: false,
          data: null,
          message: 'User not authenticated.',
        );
      }

      final uri = Uri.parse('$endPointbaseUrl/api/mobile/referralslip/');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'toMember': toMember,
          'referalStatus': referalStatus,
          'referalDetail': referalDetail,
        }),
      );

      final statusCode = response.statusCode;
      final responseData = jsonDecode(response.body);
      final isSuccess = statusCode >= 200 && statusCode < 300;

      return ApiResponse(
        statusCode: statusCode,
        isSuccess: isSuccess,
        data: responseData['data'],
        message: responseData['message'] ?? 'Referral slip submitted.',
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error submitting referral: $e',
      );
    }
  }

  static Future<ApiResponse> submitTestimonialSlip({
    required String toMember,
    required String comments,
    required List<File> imageFiles,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          isSuccess: false,
          data: null,
          message: 'User not authenticated.',
        );
      }

      final uri = Uri.parse('$endPointbaseUrl/api/mobile/testimonialslips');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['toMember'] = toMember;
      request.fields['comments'] = comments;

      for (int i = 0; i < imageFiles.length; i++) {
        final image = imageFiles[i];

        // Validation
        if (!image.existsSync()) continue;
        final length = image.lengthSync();
        if (length > 5 * 1024 * 1024) continue; // Skip >5MB files

        // Infer MIME type
        final mimeType =
            lookupMimeType(image.path) ?? 'application/octet-stream';
        final mimeSplit = mimeType.split('/');

        request.files.add(await http.MultipartFile.fromPath(
          'images',
          image.path,
          filename: image.path.split('/').last,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ));
      }

      // 🔄 Send and read response
      final streamedResponse =
          await request.send().timeout(Duration(seconds: 60));
      final responseString = await streamedResponse.stream.bytesToString();
      final responseData = jsonDecode(responseString);

      return ApiResponse(
        statusCode: streamedResponse.statusCode,
        isSuccess: streamedResponse.statusCode >= 200 &&
            streamedResponse.statusCode < 300,
        data: responseData['data'],
        message: responseData['message'] ?? 'Testimonial submitted',
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        message: 'Error submitting testimonial: $e',
        data: null,
      );
    }
  }

  static Future<ApiResponse> getTestimonialGivenList() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final uri =
          Uri.parse('$endPointbaseUrl/api/mobile/testimonialslips/given/list');
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
        message: responseData['message'] ?? '',
        extra: {
          'total': responseData['pagination']?['total'] ?? 0,
        },
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error fetching testimonials: $e',
      );
    }
  }

  static Future<ApiResponse> getTestimonialReceivedList() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final uri = Uri.parse(
          '$endPointbaseUrl/api/mobile/testimonialslips/received/list');
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
        message: responseData['message'] ?? '',
        extra: {
          'total': responseData['pagination']?['total'] ?? 0,
        },
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error fetching received testimonials: $e',
      );
    }
  }

// Inside PublicRoutesApiService

  static Future<ApiResponse> getReferralGivenList() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      final response = await http.get(
        Uri.parse('$endPointbaseUrl/api/mobile/referralslip/given/list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.statusCode == 200,
        data: json['data'],
        message: json['message'],
        extra: json['pagination'], // ✅ This is what was missing!
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        message: '❌ Error fetching referral list: $e',
        data: null,
      );
    }
  }

  static Future<ApiResponse> submitThankYouNoteSlip({
    required String toMember,
    required num amount, // ✅ Accepts number (int or double)
    required String comments,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          isSuccess: false,
          message: 'User not authenticated.',
          data: null,
        );
      }

      final uri = Uri.parse('$endPointbaseUrl/api/mobile/thankyouslips');

      final body = {
        'toMember': toMember,
        'amount': amount, // ✅ Sends as number
        'comments': comments,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final statusCode = response.statusCode;
      final data = jsonDecode(response.body);
      final isSuccess = statusCode >= 200 && statusCode < 300;

      return ApiResponse(
        statusCode: statusCode,
        isSuccess: isSuccess,
        data: data['data'],
        message: data['message'] ?? 'Thank You Slip Submitted',
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        message: 'Failed to submit Thank You Note: $e',
        data: null,
      );
    }
  }

  static Future<ApiResponse> fetchGivenThankYouNotes() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          isSuccess: false,
          message: 'Unauthorized',
          data: null,
        );
      }

      final uri =
          Uri.parse('$endPointbaseUrl/api/mobile/thankyouslips/given/list');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);
      final statusCode = response.statusCode;
      final isSuccess = statusCode >= 200 && statusCode < 300;

      return ApiResponse(
        statusCode: statusCode,
        isSuccess: isSuccess,
        message: data['message'] ?? '',
        data: data['data'],
        extra: data['pagination'], // ✅ Include pagination info here
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        message: 'Error: $e',
        data: null,
      );
    }
  }

  static Future<ApiResponse> fetchReceivedThankYouNotes() async {
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

    final response = await makeRequest(
      url: '$endPointbaseUrl/api/mobile/thankyouslips/received/list',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
    );

    // ✅ Extract only the 'data' list from response.data
    if (response.isSuccess &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final list = response.data['data'];
      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        data: list, // ✅ this is now a List<dynamic>
        message: response.data['message'] ?? '',
      );
    }

    return response;
  }

  static Future<ApiResponse> searchMemberByMobile(String mobile) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null || token.isEmpty) {
        return ApiResponse(
          statusCode: 401,
          isSuccess: false,
          message: 'Unauthorized',
          data: null,
        );
      }

      final uri =
          Uri.parse('$endPointbaseUrl/api/mobile/members/list?search=$mobile');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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

  static Future<ApiResponse> fetchMemberDetailsById(String memberId) async {
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

    final response = await makeRequest(
      url: '$endPointbaseUrl/api/mobile/members/$memberId',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.isSuccess &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        data: response.data['data'],
        message: response.data['message'] ?? '',
      );
    }

    return response;
  }

  static Future<ApiResponse> fetchReceivedReferralSlips() async {
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

    final response = await makeRequest(
      url: '$endPointbaseUrl/api/mobile/referralslip/received/list',
      method: 'GET',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.isSuccess &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final list = response.data['data'];
      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        data: list, // ✅ This is now List<dynamic>
        message: response.data['message'] ?? '',
      );
    }

    return response;
  }

  static Future<ApiResponse> fetchChapterList() async {
    final response = await makeRequest(
      url: '$endPointbaseUrl/api/mobile/chapters/list',
      method: 'GET',
      headers: {'Content-Type': 'application/json'},
    );

    if (response.isSuccess &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final List<dynamic> list = response.data['data'];
      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        data: list, // List of chapters
        message: response.data['message'] ?? '',
      );
    }

    return response;
  }

  static Future<ApiResponse> fetchZoneList() async {
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

    final response = await makeRequest(
      url: '$endPointbaseUrl/api/mobile/zones/list',
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.isSuccess &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final List<dynamic> list = response.data['data'];
      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        data: list,
        message: response.data['message'] ?? '',
      );
    }

    return response;
  }

  static Future<ApiResponse> fetchChaptersByZone(String zoneId) async {
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

    final response = await makeRequest(
      url: '$endPointbaseUrl/api/mobile/chapters/by-zone/$zoneId',
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.isSuccess &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final List<dynamic> list = response.data['data'];
      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        data: list,
        message: response.data['message'] ?? '',
      );
    }

    return response;
  }

  static Future<ApiResponse> fetchMembersByChapter(String chapterId) async {
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

    final response = await makeRequest(
      url: '$endPointbaseUrl/api/mobile/members/by-chapter/$chapterId',
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.isSuccess &&
        response.data != null &&
        response.data is Map<String, dynamic>) {
      final List<dynamic> list = response.data['data'];
      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        data: list,
        message: response.data['message'] ?? '',
      );
    }

    return response;
  }

  static Future<ApiResponse> fetchCidDetails(String cidId) async {
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

    try {
      final response = await makeRequest(
        url: '$endPointbaseUrl/api/mobile/cid/$cidId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          data: response.data['data'], // ✅ assuming structure: { data: {...} }
          message: response.data['message'] ?? 'Success',
        );
      }

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: false,
        data: null,
        message: response.message ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Exception: $e',
        data: null,
        statusCode: 500,
      );
    }
  }

  static Future<ApiResponse> fetchOthersOneToOnes(String memberId) async {
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

    try {
      final response = await makeRequest(
        url:
            '$endPointbaseUrl/api/mobile/onetoone/list/$memberId', // ✅ Fixed here
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          data: response.data['data'],
          message: response.data['message'] ?? 'Success',
        );
      }

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: false,
        data: null,
        message: response.message ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Exception: $e',
        data: null,
        statusCode: 500,
      );
    }
  }

  static Future<ApiResponse> fetchAgentaEvents() async {
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

    try {
      final response = await makeRequest(
        url: '$endPointbaseUrl/api/mobile/agenta/list',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          data: response.data['data'],
          message: response.data['message'] ?? 'Fetched successfully',
        );
      }

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: false,
        data: null,
        message: response.message ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Exception: $e',
        data: null,
        statusCode: 500,
      );
    }
  }

  static Future<ApiResponse> fetchNotifications() async {
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

    try {
      final response = await makeRequest(
        url: '$endPointbaseUrl/api/mobile/notifications/list',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.isSuccess &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        return ApiResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          data: response.data['data'],
          message: response.data['message'] ?? 'Fetched successfully',
        );
      }

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: false,
        data: null,
        message: response.message ?? 'Something went wrong',
      );
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Exception: $e',
        data: null,
        statusCode: 500,
      );
    }
  }

// Fetch Given Referrals
  static Future<ApiResponse> fetchGivenReferrals(String memberId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url: '$endPointbaseUrl/api/mobile/referralslip/given/list/$memberId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error: $e',
      );
    }
  }

// Fetch Received Referrals
  static Future<ApiResponse> fetchReceivedReferrals(String memberId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url: '$endPointbaseUrl/api/mobile/referralslip/received/list/$memberId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error: $e',
      );
    }
  }

  static Future<ApiResponse> fetchDashboardSummary(String filterType) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url:
            '$endPointbaseUrl/api/mobile/dashboard/count-summary?filterType=$filterType',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error: $e',
      );
    }
  }

  static Future<ApiResponse> fetchVisitors(String chapterId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url:
            '$endPointbaseUrl/api/mobile/visitors/chapter/$chapterId/lastSevenDays',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error: $e',
      );
    }
  }

  static Future<ApiResponse> fetchVisitorsByMember(String memberId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url: '$endPointbaseUrl/api/mobile/visitors/list/$memberId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: response.data['data'], // API returns a `data` field
        message: response.data['message'],
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error: $e',
      );
    }
  }

  static Future<ApiResponse> fetchGivenTestimonials(String userId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url: '$endPointbaseUrl/api/mobile/testimonialslips/given/list/$userId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error: $e',
      );
    }
  }

  static Future<ApiResponse> fetchReceivedTestimonials(String userId) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url:
            '$endPointbaseUrl/api/mobile/testimonialslips/received/list/$userId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: response.data['data'],
        message: response.data['message'],
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: null,
        message: 'Error: $e',
      );
    }
  }

  static Future<ApiResponse> fetchDashboardCount(
      {required String filterType}) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return ApiResponse(
        statusCode: 401,
        isSuccess: false,
        data: null,
        message: 'User not authenticated',
      );
    }

    try {
      final response = await makeRequest(
        url:
            '$endPointbaseUrl/api/mobile/dashboard/count-summary?filterType=$filterType',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final parsedData = response.data['data'] ?? {};

      return ApiResponse(
        statusCode: response.statusCode,
        isSuccess: response.isSuccess,
        data: parsedData is Map<String, dynamic> ? parsedData : {},
        message: response.data['message'] ?? 'Success',
      );
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        isSuccess: false,
        data: {},
        message: 'Error: $e',
      );
    }
  }
}
