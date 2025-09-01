import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:grip/utils/theme/Textheme.dart';

import '../backend/api-requests/no_auth_api.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enableContactPicker;
  final void Function(String? uid)? onUidFetched;

  const CustomInputField({
    super.key,
    required this.label,
    required this.isRequired,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.number,
    this.enableContactPicker = false,
    this.onUidFetched,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  String? memberName;
  String? memberUid;
  String? memberChapter;
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
        memberFound = false;
      });

      widget.controller.clear();
      widget.onUidFetched?.call(null);
      _showError("You cannot use your own number.");
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
        memberFound = false;
      });
      widget.onUidFetched?.call(null);
    }
  }

  Future<void> _fetchMemberDetails(String mobile) async {
    setState(() {
      _isLoading = true;
      memberName = null;
      memberUid = null;
      memberChapter = null;
      memberFound = false;
    });

    final response = await PublicRoutesApiService.fetchMemberDetails(mobile);

    if (response.isSuccess && response.data != null) {
      final member = response.data;

      setState(() {
        memberName =
            "${member['personalDetails']['firstName']} ${member['personalDetails']['lastName']}";
        memberUid = member['_id'];
        memberChapter = member['chapterInfo']['chapterId']['chapterName'] ?? '';
        memberFound = true;
      });

      widget.onUidFetched?.call(memberUid);
    } else {
      setState(() {
        memberName = response.message ?? 'No member found';
        memberUid = null;
        memberChapter = null;
        memberFound = false;
      });

      widget.onUidFetched?.call(null);
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 6.h,
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              maxLines: 1,
              onChanged: _onChanged,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: widget.isRequired ? widget.label : widget.label,
                hintStyle: TTextStyles.visitorsdetails,
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: widget.enableContactPicker
                    ? IconButton(
                        icon: const Icon(Icons.contacts,
                            color: Colors.black, size: 22),
                        onPressed: _pickContact,
                      )
                    : null,
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          if (memberName != null) _infoTile("Name", memberName ?? ''),
          if (memberFound && memberChapter != null && memberChapter!.isNotEmpty)
            _infoTile("Chapter", memberChapter!),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
