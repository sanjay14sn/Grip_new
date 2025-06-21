import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart' show PublicRoutesApiService;

class ChapterProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Member> _members = [];
  List<Member> get members => _members;

  ChapterDetails? _chapterDetails;
  ChapterDetails? get chapterDetails => _chapterDetails;

  Future<void> fetchChapterDetails(String chapterId) async {
    _isLoading = true;
    notifyListeners();

    final response = await PublicRoutesApiService.fetchChapterDetailsById(chapterId);

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'];
        _chapterDetails = ChapterDetails.fromJson(data);

        final membersJson = data['members'] ?? [];
        _members = membersJson.map<Member>((e) => Member.fromJson(e)).toList();
      } catch (e) {
        print('❌ Parsing error: $e');
        _members = [];
        _chapterDetails = null;
      }
    } else {
      print('❌ API call failed: ${response.message}');
    }

    _isLoading = false;
    notifyListeners();
  }
}

class Member {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
    );
  }
}

class ChapterDetails {
  final String id;
  final String chapterName;
  final String meetingVenue;
  final String meetingDayAndTime;
  final String meetingType;
  final String zoneName;
  final String cidName;
  final String cidEmail;
  final String stateName;
  final String countryName;

  ChapterDetails({
    required this.id,
    required this.chapterName,
    required this.meetingVenue,
    required this.meetingDayAndTime,
    required this.meetingType,
    required this.zoneName,
    required this.cidName,
    required this.cidEmail,
    required this.stateName,
    required this.countryName,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) {
    return ChapterDetails(
      id: json['_id'] ?? '',
      chapterName: json['chapterName'] ?? '',
      meetingVenue: json['meetingVenue'] ?? '',
      meetingDayAndTime: json['meetingDayAndTime'] ?? '',
      meetingType: json['meetingType'] ?? '',
      zoneName: json['zoneId']?['zoneName'] ?? '',
      cidName: json['cidId']?['name'] ?? '',
      cidEmail: json['cidId']?['email'] ?? '',
      stateName: json['stateName'] ?? '',
      countryName: json['countryName'] ?? '',
    );
  }
}
