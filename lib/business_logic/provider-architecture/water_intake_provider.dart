// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import '../../backend/api/day_entries_api.dart';
import '../../backend/data_models/day_entries.dart';
import '../../backend/data_models/products_in_meal.dart';
import 'date_provider.dart';

class WaterIntakeProvider with ChangeNotifier { 

  final int waterIncrement = 150;
  final UserProvider userProvider;
  final DateProvider dateProvider;
  late int neededWater;
  int currentWater = 0;
  int buttonCount = 0;

  WaterIntakeProvider(this.userProvider, this.dateProvider)
  {
    neededWater = userProvider.user!.weight * 35;
    buttonCount = (neededWater/150).ceil();
    filterWaterOutOfDayEntries();
  }

  Future<void> updateWaterIntake(int tappedIndex) async {

  currentWater = (tappedIndex + 1) * waterIncrement;
    try {
      bool success = await addNewEntry(userProvider.user!.userId, dateProvider.getSimpleDate(), currentWater, 0, 0);

      if (!success) {
        throw Exception('Failed to update water data');
      }
    } catch (e) {
      // Log the error
    }
  }

  Future<void> filterWaterOutOfDayEntries() async {
    String formattedDate = dateProvider.getSimpleDate();
    List<UserDayEntry> dayEntries = await getCurrentDayEntries(formattedDate, userProvider.user!.userId);
    dayEntries.where((entry) => entry.date == formattedDate).toList();
    for(var day in dayEntries){
    currentWater += day.water!;
    }
    notifyListeners();
  }
}

