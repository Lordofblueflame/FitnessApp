// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'user_provider.dart';
import '../../backend/api/day_entries_api.dart';
import '../../backend/data_models/day_entries.dart';
import '../../backend/data_models/products_in_meal.dart';

class WaterIntakeProvider with ChangeNotifier { 

  final int waterIncrement = 150;
  final UserProvider userProvider;
  final DateTime date;
  late int neededWater;
  int currentWater = 0;
  int buttonCount = 0;

  WaterIntakeProvider(this.userProvider, this.date)
  {
    neededWater = userProvider.user!.weight * 35;
    buttonCount = (neededWater/150).ceil();
    filterWaterOutOfDayEntries();
  }

  Future<void> updateWaterIntake(int tappedIndex) async {
    bool isActivating = (tappedIndex + 1) * waterIncrement > currentWater;

    if (isActivating) {
      currentWater = (tappedIndex + 1) * waterIncrement;
    } else {
      currentWater = tappedIndex * waterIncrement;
    }
    try {
      Map<String, dynamic> data = {
        'user_id': userProvider.user,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'water': currentWater,
        'workout': 0,
        'product_in_meal': 0,
      };
      bool success = await addNewEntry(data);
      if (!success) {
        throw Exception('Failed to update water data');
      }
    } catch (e) {
    //some log file to get error data there
    }
  }

  Future<void> filterWaterOutOfDayEntries() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    List<UserDayEntry> dayEntries = await getCurrentDayEntries(formattedDate, userProvider.user!.userId);
    dayEntries.where((entry) => DateFormat('yyyy-MM-dd').format(date) == formattedDate).toList();
    for(var day in dayEntries){
    currentWater += day.water!;
    }
  }
}

