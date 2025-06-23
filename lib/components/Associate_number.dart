import 'package:flutter/material.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;
  final bool enableContactPicker;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.isRequired,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.number,
    this.enableContactPicker = false,
  }) : super(key: key);

  Future<void> _pickContact(BuildContext context) async {
    var status = await Permission.contacts.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.contacts.request();
    }

    if (status.isGranted) {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        // ✅ No need to call refresh() here
        if (contact.phones.isNotEmpty) {
          controller.text = contact.phones.first.number;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Selected contact has no phone number.")),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: SizedBox(
        height: 5.h, // Fixed height for the input field
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: 1, // Ensure single line for fixed height
          decoration: InputDecoration(
            hintText: isRequired ? "$label" : label,
            hintStyle: TTextStyles.visitorsdetails,
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: enableContactPicker
                ? IconButton(
                    icon: Icon(Icons.contacts, color: Colors.black, size: 22),
                    onPressed: () => _pickContact(context),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
