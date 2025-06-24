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
  });

  factory DetailedMember.fromJson(Map<String, dynamic> json) {
    final personal = json['personalDetails'] ?? {};
    final contact = json['contactDetails'] ?? {};
    final business = json['businessDetails'] ?? {};
    final addressData = json['businessAddress'] ?? {};
    final chapterInfo = json['chapterInfo'] ?? {};

    return DetailedMember(
      id: json['_id'] ?? '',
      name:
          "${personal['firstName'] ?? ''} ${personal['lastName'] ?? ''}".trim(),
      company: personal['companyName'] ?? '',
      mobile: contact['mobileNumber'] ?? '',
      description: business['businessDescription'] ?? '',
      email: contact['email'] ?? '',
      website: contact['website'] ?? '',
      address: [
        addressData['addressLine1'],
        addressData['addressLine2'],
        addressData['city'],
        addressData['state'],
        addressData['postalCode'],
      ].whereType<String>().join(', '),
      chapterName: chapterInfo['chapterId']?['chapterName'] ?? '',
    );
  }
}
