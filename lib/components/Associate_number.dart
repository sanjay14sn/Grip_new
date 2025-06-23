import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:grip/utils/theme/Textheme.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enableContactPicker;
  final void Function(String? uid)? onUidFetched;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.isRequired,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.number,
    this.enableContactPicker = false,
    this.onUidFetched,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  String? memberName;
  String? memberUid;
  String? memberChapter;
  bool _isLoading = false;
  bool memberFound = false;

  Future<void> _pickContact() async {
    var status = await Permission.contacts.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null && contact.phones.isNotEmpty) {
        final phone = contact.phones.first.number.replaceAll(RegExp(r'\D'), '');
        widget.controller.text = phone;
        _onChanged(phone);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied.")),
      );
    }
  }

  void _onChanged(String value) {
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
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

    try {
      final url = Uri.parse(
          'https://api.grip.oceansoft.online/api/mobile/members/list?search=$mobile');
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['data'] is List &&
          data['data'].isNotEmpty) {
        final member = data['data'][0];

        setState(() {
          memberName =
              "${member['personalDetails']['firstName']} ${member['personalDetails']['lastName']}";
          memberUid = member['_id'];
          memberChapter =
              member['chapterInfo']['chapterId']['chapterName'] ?? '';
          memberFound = true;
        });

        widget.onUidFetched?.call(memberUid);
      } else {
        setState(() {
          memberName = 'No member found';
          memberUid = null;
          memberChapter = null;
          memberFound = false;
        });
        widget.onUidFetched?.call(null);
      }
    } catch (e) {
      setState(() {
        memberName = 'Error: $e';
        memberUid = null;
        memberChapter = null;
        memberFound = false;
      });
      widget.onUidFetched?.call(null);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              decoration: InputDecoration(
                hintText: widget.isRequired ? "${widget.label}" : widget.label,
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
                        onPressed: () => _pickContact(),
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
