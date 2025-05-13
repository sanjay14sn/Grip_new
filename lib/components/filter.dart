import 'package:flutter/material.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTime? startDate = DateTime(2024, 11, 11);
  DateTime? endDate = DateTime(2024, 11, 20);
  String selectedCategory = 'Given';

  Future<void> pickDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate! : endDate!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Add Filters", style: TTextStyles.addfilters),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    startDate = null;
                    endDate = null;
                    selectedCategory = 'Given';
                  });
                },
                child: Text("Reset", style: TTextStyles.Reset),
              ),
            ],
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "date:",
              style: TTextStyles.filterdate,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => pickDate(context, true),
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.zero,
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        startDate != null
                            ? DateFormat('dd MMM yyyy')
                                .format(startDate!)
                                .toUpperCase()
                            : 'START DATE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                "-",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => pickDate(context, false),
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.zero,
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        endDate != null
                            ? DateFormat('dd MMM yyyy')
                                .format(endDate!)
                                .toUpperCase()
                            : 'END DATE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Category:", style: TTextStyles.filterdate),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              buildRadioOption("Given"),
              SizedBox(width: 10),
              buildRadioOption("Received"),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 149,
              height: 23,
              decoration: BoxDecoration(
                gradient: Tcolors.red_button,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Apply filter logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  "APPLY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioOption(String value) {
    bool selected = selectedCategory == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = value;
          });
        },
        child: Card(
          color: selected ? Colors.white : Colors.grey[200],
          elevation: selected ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selected ? const Color(0xFF66B0CB) : Colors.grey,
                  size: 16.sp,
                ),
                SizedBox(width: 2.w),
                Text(value, style: TTextStyles.filtersgiven),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
