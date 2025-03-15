import 'package:flutter/material.dart';
import 'supabase_access.dart';
import 'main.dart';

bool isDobValidated = false;
bool debug = false;

class DateSelector extends StatefulWidget {
  const DateSelector({super.key, required this.resetEmail, required this.enforeState});
  final VoidCallback resetEmail;
  final VoidCallback enforeState;
  @override
  DateSelectorState createState() => DateSelectorState();
}

class DateSelectorState extends State<DateSelector> {
  String? selectedDate;
  List<String?> selectedDateAsList = []; // Day, Month, Year
  String? errorMessage;

  // 'rgadevrblx@gmail.com'

  final double individualWidth = 88;
  final double individualHeight = 50;
  double? widgetHeight;
  double? widgetWidth;
  final double errorMessageHeight = 30;

  void cancelEmail() {
    widget.resetEmail();
  }

  @override
  void initState() {
    super.initState();
    selectedDateAsList = ["mm", "dd", "year"];
    selectedDate = selectedDateAsList.join("/");
    widgetWidth = 360;
    widgetHeight = 330;
  }

  void _updateDate() {
    setState(() {
      selectedDate = selectedDateAsList.join("/");
    });
  }

  Future<void> validateDate() async {
    try {
      String correctDate = await supabaseAccess.readDate(supabaseAccess.getSelectedEmail() ?? '');
      setState(() {
        if (selectedDate == correctDate) {
          isDobValidated = true;
          errorMessage = 'Validation Complete!';
        } else if (selectedDate!.contains('m') || selectedDate!.contains('d') || selectedDate!.contains('y')) {
          errorMessage = 'Uncompleted Fields';
        } else {
          errorMessage = 'Incorrect Date of Birth';
        }
        if (debug) {
          errorMessage = '$correctDate ${selectedDate!}';
        }
      });
      widget.enforeState();
    } catch (e) {print(e);}
  }

  // Generate day options (01 to 31)
  List<String> days = ["dd"] + List.generate(31, (index) {
    return (index + 1).toString(); //.padLeft(2, '0');
  });

  // Generate month options (01 to 12)
  List<String> months = ["mm"] + List.generate(12, (index) {
    return (index + 1).toString(); //.padLeft(2, '0');
  });

  // Generate year options (1950 to 2025)
  List<String> years = ["year"] + List.generate(2016 - 1950 + 1, (index) {
    return (1950 + index).toString();
  });

  Widget buildDropdown(List<String> data, int valueCodeOfDefaultValue) {
    return SizedBox( 
      width: individualWidth,
      height: individualHeight,
      child:DropdownButton<String>(
        value: selectedDateAsList[valueCodeOfDefaultValue],
        onChanged: (String? newValue) {
          setState(() {
            selectedDateAsList[valueCodeOfDefaultValue] = newValue;
            _updateDate();
          });
        },
        items: data.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        dropdownColor: Colors.white,
        itemHeight: 48, 
        menuMaxHeight: 200,        
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      color: Colors.white,
      width: widgetWidth,
      height: widgetHeight,
      padding: EdgeInsets.only(
        top: 50,
        left: 45, 
        right: 45,
        bottom: 0, 
      ),
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify with DOB",
            style: h1,
          ),
          SizedBox(height: 5,),
          Text('Welcome to NFC ${supabaseAccess.getSelectedEmail() ?? 'No Email Selected'}'),
          SizedBox(height: 5,),
          Text("Enter your Date of Birth",
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildDropdown(months, 0),
            buildDropdown(days, 1),
            buildDropdown(years, 2),
          ],
        ),
        Text(errorMessage ?? '',
          style: TextStyle(
            fontSize: 10,
            color: Colors.pink,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("This is to ensure that this is really you!"),
        SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: cancelEmail,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(138, 46),
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
              ),
              child: Text(
                "Back",
                style: TextStyle(
                  color: Colors.black,
                )
              ), 
            ),
            SizedBox(width: 5,),
            TextButton(
              onPressed: validateDate, 
              style: ElevatedButton.styleFrom(
                minimumSize: Size(138, 46),
                backgroundColor: forrestGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
              ),
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                )
              ), 
            ),
          ],
        ),
      ])
    );
  }
}
