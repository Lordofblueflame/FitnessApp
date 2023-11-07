
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayButton extends StatefulWidget {
  DayButton({
    super.key,
    this.restorationId,
    DateTime? initialDate,
    this.onDateSelected,
  }) : initialDate = initialDate ?? DateTime.now();

  final void Function(DateTime)? onDateSelected;
  final DateTime initialDate;
  final String? restorationId;

  @override
  _DayButtonState createState() => _DayButtonState();
}

class _DayButtonState extends State<DayButton> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  late DateTime _selectedDate;
  final RestorableDateTime _restorableSelectedDate =
      RestorableDateTime(DateTime.now());

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_restorableSelectedDate, 'selected_date');
    _selectedDate = _restorableSelectedDate.value;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _showDatePicker() async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        _restorableSelectedDate.value = newSelectedDate;
      });

      widget.onDateSelected?.call(newSelectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _showDatePicker,
      color: Colors.green[700],
      child: Text(
        '${DateFormat('MMMM').format(_selectedDate).substring(0, 3)} ${_selectedDate.day}\n${DateFormat('EEEE').format(_selectedDate).substring(0, 3)}',
        textAlign: TextAlign.center,
      ),
    );
  }
}

