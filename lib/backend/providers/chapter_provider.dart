import 'package:flutter/material.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart'
    show PublicRoutesApiService;

/// Provider to manage chapter details and members
class ChapterProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Member> _members = [];
  List<Member> get members => _members;

  ChapterDetails? _chapterDetails;
  ChapterDetails? get chapterDetails => _chapterDetails;

  /// Fetch chapter details by chapter ID
  Future<void> fetchChapterDetails(String chapterId) async {
    _isLoading = true;
    notifyListeners();
    print('🔄 Fetching chapter details for ID: $chapterId');

    try {
      final response =
          await PublicRoutesApiService.fetchChapterDetailsById(chapterId);
      print(
          '📩 API response received: ${response.isSuccess}, data: ${response.data}');

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'];
        print('✅ Parsed data from response: $data');

        _chapterDetails = ChapterDetails.fromJson(data);
        print('🧾 ChapterDetails parsed: $_chapterDetails');

        final membersJson = data['members'] as List<dynamic>? ?? [];
        print('👥 Members data: $membersJson');

        _members = membersJson.map<Member>((e) {
          print('➡️ Parsing member: $e');
          return Member.fromJson(e as Map<String, dynamic>);
        }).toList();

        print('✅ Parsed ${_members.length} members');
      } else {
        print('❗ API request failed or data is null');
        _chapterDetails = null;
        _members = [];
      }
    } catch (e, stack) {
      print('❌ Error while parsing chapter details or members: $e');
      print('📛 Stack trace:\n$stack');
      _chapterDetails = null;
      _members = [];
    }

    _isLoading = false;
    notifyListeners();
    print('✅ Done fetching chapter details');
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

  @override
  String toString() {
    return 'Member(name: $name, email: $email)';
  }
}

class ChapterDetails {
  final String id;
  final String chapterName;
  final String meetingVenue;
  final String meetingDayAndTime;
  final String meetingType;
  final String zoneName;
  final String cidId;
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
    required this.cidId,
    required this.cidName,
    required this.cidEmail,
    required this.stateName,
    required this.countryName,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) {
    final cidData = json['cidId'] ?? {};
    final zoneData = json['zoneId'] ?? {};

    return ChapterDetails(
      id: json['_id'] ?? '',
      chapterName: json['chapterName'] ?? '',
      meetingVenue: json['meetingVenue'] ?? '',
      meetingDayAndTime: json['meetingDayAndTime'] ?? '',
      meetingType: json['meetingType'] ?? '',
      zoneName: zoneData['zoneName'] ?? '',
      cidId: cidData['_id'] ?? '',
      cidName: cidData['name'] ?? '',
      cidEmail: cidData['email'] ?? '',
      stateName: json['stateName'] ?? '',
      countryName: json['countryName'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Chapter(chapterName: $chapterName, cidName: $cidName)';
  }
}
