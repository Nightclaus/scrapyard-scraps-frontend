import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';

Future<String?> scanNFC() async {
  bool isAvailable = await NfcManager.instance.isAvailable();

  if (!isAvailable) {
    print("NFC not available on this device.");
    return null;
  }

  Completer<String?> completer = Completer();
  Timer timer = Timer(Duration(seconds: 10), () {
    if (!completer.isCompleted) {
      print("NFC scan timed out.");
      NfcManager.instance.stopSession();
      completer.complete(null);
    }
  });

  NfcManager.instance.startSession(
    onDiscovered: (NfcTag tag) async {
      timer.cancel(); // Stop the timer since we found a tag

      // Extract tag data and check if it's empty
      String? tagValue = tag.data.toString();

      if (tagValue.isEmpty) {
        print("Empty NFC tag scanned. Stopping session.");
        await NfcManager.instance.stopSession();  // Stop NFC session if the tag is empty
        if (!completer.isCompleted) completer.complete(null); // Complete with null
        return;
      }

      print("NFC Tag Found: $tagValue");

      await NfcManager.instance.stopSession(); // Stop NFC session after processing tag
      if (!completer.isCompleted) completer.complete(tagValue);  // Complete with the tag value
    },
  );

  return completer.future;
}