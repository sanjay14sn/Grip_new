// lib/models/filter_options.dart

class FilterOptions {
  DateTime? startDate;
  DateTime? endDate;
  String category; // "Given" or "Received"

  FilterOptions({
    this.startDate,
    this.endDate,
    this.category = 'Given',
  });

  void reset() {
    startDate = null;
    endDate = null;
    category = 'Given';
  }

  bool isWithinRange(DateTime date) {
    if (startDate != null && date.isBefore(startDate!)) return false;
    if (endDate != null && date.isAfter(endDate!)) return false;
    return true;
  }
}
