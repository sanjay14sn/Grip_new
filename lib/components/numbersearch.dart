import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grip/backend/api-requests/imageurl.dart';
import 'package:grip/backend/api-requests/no_auth_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:grip/pages/chapter_detailes/membermodel.dart';
import 'package:grip/utils/theme/Textheme.dart';

class NumberSearch extends StatefulWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enableContactPicker;

  const NumberSearch({
    super.key,
    required this.label,
    required this.isRequired,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.number,
    this.enableContactPicker = false,
  });

  @override
  State<NumberSearch> createState() => _NumberSearchState();
}

class _NumberSearchState extends State<NumberSearch> {
  String? memberName;
  String? memberUid;
  String? memberChapter;
  Map<String, dynamic>? personalDetails;
  bool _isLoading = false;
  bool memberFound = false;
  String? loggedInMobile;
  bool isSameUser = false;

  @override
  void initState() {
    super.initState();
    _loadLoggedInMobile();
  }

  Future<void> _loadLoggedInMobile() async {
    final storage = FlutterSecureStorage();
    final userDataString = await storage.read(key: 'user_data');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      setState(() {
        loggedInMobile = userData['mobileNumber'];
      });
    }
  }

  Future<void> _pickContact() async {
    var status = await Permission.contacts.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null && contact.phones.isNotEmpty) {
        String phone =
            contact.phones.first.number.replaceAll(RegExp(r'\D'), '');
        if (phone.startsWith('91') && phone.length > 10) {
          phone = phone.substring(phone.length - 10);
        }

        if (phone.length == 10) {
          widget.controller.text = phone;
          _onChanged(phone);
        } else {
          _showError("Please select a valid 10-digit number.");
        }
      }
    } else {
      _showError("Permission denied.");
    }
  }

  void _onChanged(String value) {
    String cleaned = value.replaceAll(RegExp(r'\D'), '');

    if (cleaned.startsWith('91') && cleaned.length > 10) {
      cleaned = cleaned.substring(cleaned.length - 10);
    }

    widget.controller.text = cleaned;

    if (cleaned == loggedInMobile) {
      setState(() {
        isSameUser = true;
        memberName = null;
        memberUid = null;
        memberChapter = null;
        personalDetails = null;
        memberFound = false;
      });
      _showError("You cannot use your own number.");
      widget.controller.clear();
      return;
    } else {
      setState(() => isSameUser = false);
    }

    if (cleaned.length == 10) {
      _fetchMemberDetails(cleaned);
    } else {
      setState(() {
        memberName = null;
        memberUid = null;
        memberChapter = null;
        personalDetails = null;
        memberFound = false;
      });
    }
  }

  Future<void> _fetchMemberDetails(String mobile) async {
    setState(() {
      _isLoading = true;
      memberFound = false;
      memberName = null;
      memberUid = null;
      memberChapter = null;
      personalDetails = null;
    });

    final response = await PublicRoutesApiService.fetchMemberDetails(mobile);

    if (response.isSuccess && response.data != null) {
      final member = response.data;

      setState(() {
        memberName =
            "${member['personalDetails']['firstName']} ${member['personalDetails']['lastName']}";
        memberUid = member['_id'];
        memberChapter = member['chapterInfo']['chapterId']['chapterName'] ?? '';
        personalDetails = member['personalDetails'];
        personalDetails!['email'] = member['contactDetails']['email'];
        personalDetails!['website'] = member['contactDetails']['website'];
        personalDetails!['businessDescription'] =
            member['businessDetails']['businessDescription'];
        memberFound = true;
      });

      String profileImageUrl = '';
      if (personalDetails!['profileImage'] != null &&
          personalDetails!['profileImage']['docPath'] != null &&
          personalDetails!['profileImage']['docName'] != null) {
        profileImageUrl =
            "${UrlService.imageBaseUrl}/${personalDetails!['profileImage']['docPath']}/${personalDetails!['profileImage']['docName']}";
      }

      final memberModel = MemberModel(
        id: memberUid!,
        name: memberName ?? '',
        role: '',
        profileImageUrl: profileImageUrl,
        company: personalDetails!['companyName'] ?? '',
        phone: widget.controller.text,
        email: personalDetails!['email'] ?? '',
        website: personalDetails!['website'] ?? '',
        address: '',
        businessDescription: personalDetails!['businessDescription'] ?? '',
      );

      context.push('/Chaptermember', extra: memberModel);
      widget.controller.clear();
    } else {
      _showError(response.message ?? "No member found.");
      widget.controller.clear();
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Color(0xFFDC2A29)),
    );
    widget.controller.clear(); // ✅ clear input on error
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            maxLines: 1,
            onChanged: _onChanged,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TTextStyles.visitorsdetails
                .copyWith(color: Colors.black), // 🔹 Text color
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
              hintText: widget.label,
              hintStyle: TTextStyles.visitorsdetails
                  .copyWith(color: Colors.black), // 🔹 Hint color
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: widget.enableContactPicker
                  ? Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: const Icon(Icons.contacts,
                            color: Colors.black, size: 20),
                        onPressed: _pickContact,
                      ),
                    )
                  : null,
              suffixIconConstraints: BoxConstraints(
                minHeight: 36,
                minWidth: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
