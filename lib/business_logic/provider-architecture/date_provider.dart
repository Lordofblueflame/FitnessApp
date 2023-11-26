import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class DateProvider with ChangeNotifier   {
  late DateTime date;
  late String _dateSimpleFormat;

  DateProvider(this.date)
  {
    _simpleFormat();
  }

  void setDate(DateTime newDate)
  {
    date = newDate;
    _simpleFormat();
  }

  void _simpleFormat()
  {
    _dateSimpleFormat = DateFormat('yyyy-MM-dd').format(date);
  }

  String getSimpleDate()
  {
    return _dateSimpleFormat;
  }
}
