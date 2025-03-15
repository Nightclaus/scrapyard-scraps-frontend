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
      timer.cancel(); // Stop timer since we found a tag

      String? tagValue = tag.data.toString();
      print("NFC Tag Found: $tagValue");

      await NfcManager.instance.stopSession();
      if (!completer.isCompleted) completer.complete(tagValue);
    },
  );

  return completer.future;
}

