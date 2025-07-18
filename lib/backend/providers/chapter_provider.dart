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

    try {
      final response =
          await PublicRoutesApiService.fetchChapterDetailsById(chapterId);

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'];

        _chapterDetails = ChapterDetails.fromJson(data);

        final membersJson = data['members'] as List<dynamic>? ?? [];

        _members = membersJson.map<Member>((e) {
          return Member.fromJson(e as Map<String, dynamic>);
        }).toList();
      } else {
        _chapterDetails = null;
        _members = [];
      }
    } catch (e, stack) {
      _chapterDetails = null;
      _members = [];
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

  @override
  String toString() => 'Member(name: $name, email: $email)';
}

class ChapterDetails {
  final String id;
  final String chapterName;
  final String meetingVenue;
  final String meetingDayAndTime;
  final String meetingType;
  final String zoneName;
  final List<Cid> cids; // 👈 Updated
  final String stateName;
  final String countryName;

  ChapterDetails({
    required this.id,
    required this.chapterName,
    required this.meetingVenue,
    required this.meetingDayAndTime,
    required this.meetingType,
    required this.zoneName,
    required this.cids,
    required this.stateName,
    required this.countryName,
  });

  factory ChapterDetails.fromJson(Map<String, dynamic> json) {
    final zoneData = json['zoneId'] ?? {};
    final cidList = (json['cidId'] as List<dynamic>? ?? []).map((cidJson) {
      final cidMap = cidJson as Map<String, dynamic>;
      return Cid(
        id: cidMap['_id'] ?? '',
        name: cidMap['name'] ?? '',
        email: cidMap['email'] ?? '',
      );
    }).toList();

    return ChapterDetails(
      id: json['_id'] ?? '',
      chapterName: json['chapterName'] ?? '',
      meetingVenue: json['meetingVenue'] ?? '',
      meetingDayAndTime: json['meetingDayAndTime'] ?? '',
      meetingType: json['meetingType'] ?? '',
      zoneName: zoneData['zoneName'] ?? '',
      cids: cidList,
      stateName: json['stateName'] ?? '',
      countryName: json['countryName'] ?? '',
    );
  }
}

class Cid {
  final String id;
  final String name;
  final String email;

  Cid({required this.id, required this.name, required this.email});
}
