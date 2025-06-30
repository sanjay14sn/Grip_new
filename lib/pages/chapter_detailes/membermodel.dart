class MemberModel {
  final String id; // ✅ Add this
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
    required this.id, // ✅ Include in constructor
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
      id: json['_id'] ?? '', // ✅ Read ID from backend
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
  final String id; // ✅ Add this
  final String name;
  final String company;
  final String phone;
  final String? role;
  final String? website;
  final String? chapterName;
  final String? businessDescription;
  final String? email;
  final String? address;
  final String? cidId;

  othersMemberModel({
    required this.id, // ✅ Include in constructor
    required this.name,
    required this.company,
    required this.phone,
    this.role,
    this.website,
    this.chapterName,
    this.businessDescription,
    this.email,
    this.address,
    this.cidId,
  });

  factory othersMemberModel.fromJson(Map<String, dynamic> json) {
    final personal = json['personalDetails'] ?? {};
    final contact = json['contactDetails'] ?? {};
    final chapterInfo = json['chapterInfo']?['chapterId'] ?? {};
    final business = json['businessDetails'] ?? {};
    final address = json['businessAddress'] ?? {};

    return othersMemberModel(
      id: json['_id'] ?? '', // ✅ Extract the ID from root level
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
      cidId: chapterInfo['cidId'],
    );
  }
}
