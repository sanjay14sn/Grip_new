import 'package:flutter/material.dart';
import 'package:grip/components/filter_options.dart';
import 'package:grip/utils/constants/Tcolors.dart';
import 'package:grip/utils/theme/Textheme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class FilterDialog extends StatefulWidget {
  final FilterOptions initialFilter;
  final bool showCategory; // Control whether to show "Given/Received"

  const FilterDialog({
    super.key,
    required this.initialFilter,
    this.showCategory = true,
  });

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late DateTime? startDate;
  late DateTime? endDate;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    startDate = widget.initialFilter.startDate;
    endDate = widget.initialFilter.endDate;
    selectedCategory = widget.initialFilter.category;
  }

  Future<void> pickDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFC6221A), // Red color like your button
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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

  void applyFilter() {
    Navigator.pop(
      context,
      FilterOptions(
        startDate: startDate,
        endDate: endDate,
        category: selectedCategory,
      ),
    );
  }

  void resetFilter() {
    Navigator.pop(
      context,
      FilterOptions(
        startDate: null,
        endDate: null,
        category: 'Given', // or keep it empty string '' if needed
      ),
    );
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
          /// Header
          Row(
            children: [
              Text("Add Filters", style: TTextStyles.addfilters),
              const Spacer(),
              GestureDetector(
                onTap: resetFilter, // now applies immediately
                child: Text("Reset", style: TTextStyles.Reset),
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          /// Date label
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Date:", style: TTextStyles.filterdate),
          ),
          SizedBox(height: 1.h),

          /// Date pickers
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => pickDate(context, true),
                  child: _buildDateCard(startDate, "START DATE"),
                ),
              ),
              const SizedBox(width: 10),
              const Text("-",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => pickDate(context, false),
                  child: _buildDateCard(endDate, "END DATE"),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          /// Category (conditionally shown)
          if (widget.showCategory) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Category:", style: TTextStyles.filterdate),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                buildRadioOption("Given"),
                const SizedBox(width: 10),
                buildRadioOption("Received"),
              ],
            ),
            SizedBox(height: 2.h),
          ],

          /// Apply Button
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
                onPressed: applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
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

  /// Builds the date card
  Widget _buildDateCard(DateTime? date, String label) {
    return Card(
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
          date != null
              ? DateFormat('dd MMM yyyy').format(date).toUpperCase()
              : label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  /// Builds the radio option for category
  Widget buildRadioOption(String value) {
    final selected = selectedCategory == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedCategory = value),
        child: Card(
          color: selected ? Colors.white : Colors.grey[200],
          elevation: selected ? 4 : 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
