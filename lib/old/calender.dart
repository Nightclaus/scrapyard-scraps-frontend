import 'package:flutter/material.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});
  @override
  DateSelectorState createState() => DateSelectorState();
}

class DateSelectorState extends State<DateSelector> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = _getFormattedDate(DateTime.now()); // Default to today's date
  }

  String _getFormattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}";
  }

  void _showDatePicker(BuildContext context) async {
    DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    )) ?? DateTime.now();

    setState(() {
      selectedDate = _getFormattedDate(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedDate ?? 'Select Date',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Selected Date: $selectedDate",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}