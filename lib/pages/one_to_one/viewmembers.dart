import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/main.dart';
import 'package:sizer/sizer.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({super.key});

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  bool isExpanded = true;
  String searchText = '';
  String? selectedMember;

  final List<String> allMembers = [
    "Akash Kumar.P",
    "Akshya.R",
    "Arun.K",
    "Akilan.A",
    "Balu.M",
    "Balamurugan.A",
    "Balaji.S",
    "Balu.K",
    "Dharshini.J",
    "Farzi.M",
    "Iniyan.S",
    "Kiran.T",
    "Santhosh.B",
    "Santhosh.A",
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMembers = allMembers
        .where(
            (member) => member.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Icon
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),

                  // Header Button
                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC83837),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "OTHERS ONE TO ONES",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Search Field with Expand/Collapse Button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.red),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                searchText = val;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Search",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Members List Header with Expand/Collapse
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.2.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Aram Members List:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Member Items
                  if (isExpanded)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filteredMembers.length,
                          itemBuilder: (context, index) {
                            final member = filteredMembers[index];
                            final isSelected = member == selectedMember;
                            return ListTile(
                              dense: true,
                              title: Text(
                                member,
                                style: TextStyle(
                                  color: isSelected ? Colors.red : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                context.push('/OthersOneToOnesPage');
                                print("tapped!!!");
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
