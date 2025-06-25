import 'package:grip/pages/one_to_one/others_one_to_one.dart';

class MemberModel {
  final String name;
  final String company;
  final String phone;
  final String? role;
  final String? website;
  final String? chapterName;
  final String? businessDescription;
  final String? email;
  final String? address;

  MemberModel({
    required this.name,
    required this.company,
    required this.phone,
    this.role,
    this.website,
    this.chapterName,
    this.businessDescription,
    this.email,
    this.address,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'],
      website: json['website'],
      chapterName: json['chapterName'],
      businessDescription: json['businessDescription'],
      email: json['email'],
      address: json['address'],
    );
  }
}

class othersMemberModel {
  final String name;
  final String company;
  final String phone;
  final String? role;
  final String? website;
  final String? chapterName;
  final String? businessDescription;
  final String? email;
  final String? address;

  othersMemberModel({
    required this.name,
    required this.company,
    required this.phone,
    this.role,
    this.website,
    this.chapterName,
    this.businessDescription,
    this.email,
    this.address,
  });
  factory othersMemberModel.fromJson(Map<String, dynamic> json) {
    final personal = json['personalDetails'] ?? {};
    final contact = json['contactDetails'] ?? {};
    final chapterInfo = json['chapterInfo']?['chapterId'] ?? {};
    final business = json['businessDetails'] ?? {};
    final address = json['businessAddress'] ?? {};

    return othersMemberModel(
      name:
          '${personal['firstName'] ?? ''} ${personal['lastName'] ?? ''}'.trim(),
      company: personal['companyName'] ?? '',
      phone: contact['mobileNumber'] ?? '',
      role: personal['categoryRepresented'],
      website: contact['website'],
      chapterName: chapterInfo['chapterName'],
      businessDescription: business['businessDescription'],
      email: contact['email'],
      address: address['addressLine1'],
    );
  }
}
