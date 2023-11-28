import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/provider_architecture/date_provider.dart';

class DayButton extends StatelessWidget {
  const DayButton({
    super.key,
    this.restorationId,
    DateTime? initialDate,
    this.onDateSelected,
  });

  final void Function(DateTime)? onDateSelected;
  final String? restorationId;

  void _showDatePicker(BuildContext context) async {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: dateProvider.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (newSelectedDate != null) {
      dateProvider.setDate(newSelectedDate);
      onDateSelected?.call(newSelectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double iconSize = screenSize.width > 360 ? 24 : 20;
    double fontSize = screenSize.width * 0.04;

    return Consumer<DateProvider>(
      builder: (context, dateProvider, child) {
        return MaterialButton(
          onPressed: () => _showDatePicker(context),
          color: Colors.lightGreen[300],
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: iconSize, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '${DateFormat('MMM dd, EEE').format(dateProvider.date)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
