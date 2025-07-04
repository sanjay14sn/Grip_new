import 'package:grip/backend/api-requests/imageurl.dart';

class DetailedMember {
  final String id;
  final String name;
  final String company;
  final String mobile;
  final String description;
  final String email;
  final String website;
  final String address;
  final String chapterName;
  final String? cid;
  final String? profileImageUrl; // ✅ added
  final String? category; // 👈 add this

  DetailedMember({
    required this.id,
    required this.name,
    required this.company,
    required this.mobile,
    required this.description,
    required this.email,
    required this.website,
    required this.address,
    required this.chapterName,
    this.cid,
    this.category, // 👈 include in constructor
    this.profileImageUrl, // ✅ constructor
  });

  factory DetailedMember.fromJson(Map<String, dynamic> json) {
    final personal = json['personalDetails'] ?? {};
    final contact = json['contactDetails'] ?? {};
    final business = json['businessDetails'] ?? {};
    final addressData = json['businessAddress'] ?? {};
    final chapterInfo = json['chapterInfo'] ?? {};
    final chapterId = chapterInfo['chapterId'] ?? {};
    final profile = personal['profileImage'];

    return DetailedMember(
      id: json['_id']?.toString() ?? '',
      name:
          "${personal['firstName'] ?? ''} ${personal['lastName'] ?? ''}".trim(),
      company: personal['companyName']?.toString() ?? '',
      mobile: contact['mobileNumber']?.toString() ?? '',
      description: business['businessDescription']?.toString() ?? '',
      email: contact['email']?.toString() ?? '',
      website: contact['website']?.toString() ?? '',
      address: [
        addressData['addressLine1'],
        addressData['addressLine2'],
        addressData['city'],
        addressData['state'],
        addressData['postalCode'],
      ]
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .join(', '),
      chapterName: chapterId['chapterName']?.toString() ?? '',
      cid: chapterInfo['cidId']?.toString(),
      category: personal['categoryRepresented']?.toString(), // ✅ FIXED HERE
      profileImageUrl: (profile != null)
          ? "${UrlService.imageBaseUrl}/${profile['docPath']}/${profile['docName']}"
          : null,
    );
  }
}
