import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlService {
  static final String imageBaseUrl = dotenv.env['IMAGE_BASE_URL'] ?? '';
}
