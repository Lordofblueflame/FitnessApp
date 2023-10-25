
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayButton extends StatefulWidget
{
  DayButton({Key? key, this.restorationId, DateTime? initialDate, this.onDateSelected})
        : initialDate = initialDate ?? DateTime.now(),
        super(key: key);

  final void Function(DateTime)? onDateSelected;
  final DateTime initialDate;
  final String? restorationId;

  @override
  DayButtonState createState() => DayButtonState();
}

class DayButtonState extends State<DayButton> with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId; 

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: widget.initialDate.millisecondsSinceEpoch,       
      );
    },   
  );
  
  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;

      });

      widget.onDateSelected?.call(newSelectedDate);
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return MaterialButton 
    (
      onPressed: () {
        _restorableDatePickerRouteFuture.present();
      },
      color: Colors.green[700],     
      child: Text
        ('${DateFormat('MMMM').format(_selectedDate.value).substring(0,3)} ${_selectedDate.value.day}\n${DateFormat('EEEE').format(_selectedDate.value).substring(0,3)}',
        textAlign: TextAlign.center),
    );
  }
}

// po kliknięciu podmień dane na widoku - jakaś funkcja