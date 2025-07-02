import 'package:grip/backend/api-requests/imageurl.dart';

class PaymentItem {
  final String id;
  final String title;
  final String? imageUrl;
  final int amount;
  final DateTime date;
  final bool paymentRequired;

  PaymentItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.amount,
    required this.date,
    required this.paymentRequired,
  });

  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    final imageObj = json['image'];
    final imagePath = (imageObj != null)
        ? "${UrlService.imageBaseUrl}/${imageObj['docPath']}/${imageObj['docName']}"
        : null;

    return PaymentItem(
      id: json['_id'],
      title: json['topic'] ?? json['purpose'],
      imageUrl: imagePath,
      amount: json['amount'] ?? 0,
      date: DateTime.parse(json['date']),
      paymentRequired: json['paymentRequired'] ?? false,
    );
  }
}
