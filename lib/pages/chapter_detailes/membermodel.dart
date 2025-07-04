import 'package:grip/backend/api-requests/imageurl.dart';

class MemberModel {
  final String id;
  final String name;
  final String company;
  final String phone;
  final String? role;
  final String? website;
  final String? category;
  final String? chapterName;
  final String? businessDescription;
  final String? email;
  final String? address;
  final String? profileImageUrl; // ✅ Add this

  MemberModel({
    required this.id,
    required this.name,
    required this.company,
    required this.phone,
    this.role,
    this.category,
    this.website,
    this.chapterName,
    this.businessDescription,
    this.email,
    this.address,
    this.profileImageUrl, // ✅ Add to constructor
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    final personal = json['personalDetails'] ?? {};
    final contact = json['contactDetails'] ?? {};
    final chapterInfo = json['chapterInfo']?['chapterId'] ?? {};
    final business = json['businessDetails'] ?? {};
    final address = json['businessAddress'] ?? {};
    final profile = personal['profileImage'];

    return MemberModel(
      id: json['_id'] ?? '',
      name:
          '${personal['firstName'] ?? ''} ${personal['lastName'] ?? ''}'.trim(),
      company: personal['companyName'] ?? '',
      phone: contact['mobileNumber'] ?? '',
      role: business['categoryRepresented'], // ✅ FIXED HERE
      website: contact['website'],
      chapterName: chapterInfo['chapterName'],
      businessDescription: business['businessDescription'],
      email: contact['email'],
      address: address['addressLine1'],
      profileImageUrl: (profile != null)
          ? "${UrlService.imageBaseUrl}/${profile['docPath']}/${profile['docName']}"
          : null,
    );
  }
}

class othersMemberModel {
  final String id;
  final String name;
  final String company;
  final String phone;
  final String? role;
  final String? website;
  final String? chapterName;
  final String? businessDescription;
  final String? email;
  final String? address;
  final String? category;
  final String? cidId;
  final String? profileImageUrl; // ✅ Add this

  othersMemberModel({
    required this.id,
    required this.name,
    required this.company,
    required this.phone,
    this.role,
    this.category,
    this.website,
    this.chapterName,
    this.businessDescription,
    this.email,
    this.address,
    this.cidId,
    this.profileImageUrl, // ✅ Add to constructor
  });

  factory othersMemberModel.fromJson(Map<String, dynamic> json) {
    final personal = json['personalDetails'] ?? {};
    final contact = json['contactDetails'] ?? {};
    final chapterInfo = json['chapterInfo']?['chapterId'] ?? {};
    final business = json['businessDetails'] ?? {};
    final address = json['businessAddress'] ?? {};
    final profile = personal['profileImage'];

    String? profileImageUrl;
    if (profile != null &&
        profile['docPath'] != null &&
        profile['docName'] != null) {
      profileImageUrl =
          "${UrlService.imageBaseUrl}/${profile['docPath']}/${profile['docName']}";
    }

    return othersMemberModel(
      id: json['_id'] ?? '',
      name:
          '${personal['firstName'] ?? ''} ${personal['lastName'] ?? ''}'.trim(),
      company: personal['companyName'] ?? '',
      phone: contact['mobileNumber'] ?? '',
      category: business['categoryRepresented'], // ✅ FIXED LINE HERE
      website: contact['website'],
      chapterName: chapterInfo['chapterName'],
      businessDescription: business['businessDescription'],
      email: contact['email'],
      address: address['addressLine1'],
      cidId: chapterInfo['cidId'],
      profileImageUrl: profileImageUrl,
    );
  }
}
