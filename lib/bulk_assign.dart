import 'package:flutter/material.dart';
import 'supabase_access.dart';
import 'nfc_access.dart';

String _errorLogs = '';

class BulkAssign extends StatefulWidget {
  const BulkAssign({super.key});

  @override
  BulkAssignState createState() => BulkAssignState();
}

class BulkAssignState extends State<BulkAssign> {
  bool isBulkAssignActive = false;
  TextEditingController customScrapController = TextEditingController();
  List<String> nfcValuesInTheBulk = [];
  bool isRunning = false;

  void toogleBulkPairing() {
    isBulkAssignActive = !isBulkAssignActive;
    //supabaseAccess.bulkAssignScrapsWithNfc(['test', 'test2'], 5); // API test

    if (!isBulkAssignActive) { // Just Switched back
      // Finalisation Logic
      try {
        isRunning=false;
        supabaseAccess.bulkAssignScrapsWithNfc(nfcValuesInTheBulk, int.parse(customScrapController.text));
        _errorLogs = 'Added ${int.parse(customScrapController.text)} Scraps to ${nfcValuesInTheBulk.length} users';

        nfcValuesInTheBulk = []; // reset
      } catch (e) {
        print(e); // Probably value error
        isRunning=true; // Back at it
        isBulkAssignActive = !isBulkAssignActive; // retoggle cos the thing failed
        _errorLogs = 'Invalid Integer Value';
      }
    } else { 
      _errorLogs = ''; // clear
      // Begin NFC Bulking // Aka Start listening
      isRunning=true;
      runUntilTerminated();
    }
    setState(() {});
  }

  Future<void> runUntilTerminated() async {
    while (isRunning) {
      try {
        String? nfcValue = await scanNFC();
        await Future.delayed(Duration(milliseconds: 100));

        if (nfcValue == null) throw Exception("No NFC Detected");
        setState(() {
          nfcValuesInTheBulk.add(nfcValue);
        });
      } catch (e) {
        print("Error: $e");
        _errorLogs = 'You do not have NFC capabilites';
        break;
      }
    }
    print("Process has been terminated.");
  }

  Future<void> TESTrunUntilTerminated() async {
    while (isRunning) {
      try {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          nfcValuesInTheBulk.add('entry');
        });
      } catch (e) {
        print("Error: $e");
        _errorLogs = 'You do not have NFC capabilites';
        break;
      }
    }
    print("Process has been terminated.");
  }

  Widget getCustomScrapBox() {
    return SizedBox(
      width: 40,
      height: 40,
      child:TextField(
        controller: customScrapController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 3
          ),
          border: OutlineInputBorder(),
          hintText: 'Custom',
          hintStyle: TextStyle(
            fontSize: 8, // Adjust the hint text font size if needed
            //height: 0, // Adjust the height for tight control over padding
          ),
        ),
        //onSubmitted: (value) {_addScrap(int.parse(customScrapController.text));},
      ),
    );
  }

  Widget toogleBulkPairingButton() {
    return SizedBox(
      width: 190,
      height: 40,
      child: ElevatedButton(
        onPressed: toogleBulkPairing,
        style: ElevatedButton.styleFrom(
          backgroundColor: isBulkAssignActive ? Colors.red : Colors.green, // Red color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Square shape
          ), // Square dimensions
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${nfcValuesInTheBulk.length} | ${isBulkAssignActive ? 'Finalise' : 'Start Bulk Assign'}'),
            (_errorLogs != '') ? Text(_errorLogs, style: TextStyle(
              fontSize: 6,
              color: Colors.black,
            ),) : SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 240,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getCustomScrapBox(),
          toogleBulkPairingButton()
        ],
      ),
    );
  }
}