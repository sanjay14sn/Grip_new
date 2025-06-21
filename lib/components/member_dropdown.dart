import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:grip/backend/providers/chapter_provider.dart';

class MemberDropdown extends StatefulWidget {
  final void Function(
      String name, String uid, String chapterId, String chapterName)? onSelect;

  const MemberDropdown({super.key, this.onSelect});

  @override
  State<MemberDropdown> createState() => _MemberDropdownState();
}

class _MemberDropdownState extends State<MemberDropdown> {
  String? selectedPerson;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChapterProvider>(context);
    final chapter = provider.chapterDetails;

    // Combine members and CID into one dropdown list
    final items = [
      ...provider.members.map((e) => {'name': e.name, 'id': e.id}),
      if (chapter != null) {'name': chapter.cidName, 'id': 'CID'}
    ];

    return Container(
      height: 6.25.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Colors.white,
                value: selectedPerson,
                hint: const Text(
                  "To:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                items: items.map((e) {
                  return DropdownMenuItem<String>(
                    value: e['name'],
                    child: Text(e['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPerson = value;
                  });

                  final selected = items.firstWhere((e) => e['name'] == value);
                  final uid = selected['id'] ?? '';
                  final name = selected['name'] ?? '';
                  final chapterId = chapter?.id ?? '';
                  final chapterName = chapter?.chapterName ?? '';

                  // Print or trigger callback
                  print('✅ Name: $name');
                  print('🆔 UID: $uid');
                  print('🏷️ Chapter ID: $chapterId');
                  print('📛 Chapter Name: $chapterName');

                  widget.onSelect?.call(name, uid, chapterId, chapterName);
                },
              ),
            ),
          ),
          const Icon(Icons.search, color: Color(0xFFC6221A)),
        ],
      ),
    );
  }
}
