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
}

class ChapterDetail {
  final String chapterName;
  final String meetingVenue;
  final String meetingType;
  final Map<String, dynamic> cid;
  final List<dynamic> members;

  ChapterDetail({
    required this.chapterName,
    required this.meetingVenue,
    required this.meetingType,
    required this.cid,
    required this.members,
  });

  factory ChapterDetail.fromJson(Map<String, dynamic> json) {
    return ChapterDetail(
      chapterName: json['chapterName'],
      meetingVenue: json['meetingVenue'],
      meetingType: json['meetingType'],
      cid: json['cidId'],
      members: json['members'],
    );
  }
}
