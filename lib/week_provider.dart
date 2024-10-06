import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'week_data_model.dart';

class WeekProvider with ChangeNotifier {
  List<WeekData> _weeksData = [];
  WeekData? _selectedWeek;

  List<WeekData> get weeksData => _weeksData;
  WeekData? get selectedWeek => _selectedWeek;

  Future<void> loadWeeksData() async {
    final String response = await rootBundle.loadString('assets/weeks_data.json');
    final data = await json.decode(response) as List;
    _weeksData = data.map((item) => WeekData.fromJson(item)).toList();
    notifyListeners();
  }

  void selectWeek(WeekData week) {
    _selectedWeek = week;
    notifyListeners();
  }

  void selectWeekByWeek(int weekNumber) {
    // Check if weeks data is loaded and not empty
    if (_weeksData.isEmpty) {
      print("Weeks data is not loaded yet.");
      return;
    }

    // Debugging: Print the current state of weeks data and week number
    print("Attempting to select week: $weekNumber");
    print("Total weeks data available: ${_weeksData.length}");

    for (var weekData in _weeksData) {
      final weekRange = weekData.weekRange.split('-');
      
      // Check if weekRange is a single week or a range
      int startWeek = int.parse(weekRange[0]);
      int endWeek = weekRange.length > 1 ? int.parse(weekRange[1]) : startWeek;

      if (weekNumber >= startWeek && weekNumber <= endWeek) {
        _selectedWeek = weekData;
        print("Week selected: ${weekData.weekRange}");
        break;
      }
    }

    // Check if a week was selected, if not show a message
    if (_selectedWeek == null) {
      print("No valid week found for week number: $weekNumber");
    }

    notifyListeners();
  }
}

