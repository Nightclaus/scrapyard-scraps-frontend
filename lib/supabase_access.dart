import 'package:supabase_flutter/supabase_flutter.dart';
const String local_system_ver = 'v0.2';

final SupabaseAccess supabaseAccess = SupabaseAccess();

class SupabaseAccess {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? selectedEmail;

  void setSelectedEmail(newEmail) {
    selectedEmail = newEmail;
  }

  String? getSelectedEmail() {
    return selectedEmail;
  }

  // Error Testing

  Future<bool> doesTableExist(String tableName) async {
  try {
    final _ = await _supabase.from(tableName).select().limit(10);
    return true;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

  void checkTable() async {
    bool exists = await doesTableExist('users');
    print(exists ? 'Table exists' : 'Table does not exist');
  }

  // ================== Database Operations ================== //

  Future<List<List<String>>> getAllEntriesFromDatabase() async {
    final response = await _supabase.from('users').select('Pronouns, full_name, email');

    List<List<String>> allEntries = [];

    for (var user in response) {
      String gender = user['Pronouns'] ?? 'Unknown';
      String name = user['full_name'] ?? 'Unknown';
      print(name);
      String email = user['email'] ?? 'Unknown';

      allEntries.add([gender, name, email]);
    }

    return allEntries;
  }

  Future<void> addTransferLog(String userEmail, double amountChanged, double newTotal) async {
    try {
      final _ = await Supabase.instance.client
          .from('transfer_logs')
          .insert({
            'user_email': userEmail,
            'amount_changed': amountChanged,
            'new_total': newTotal,
          });

      print('Transfer log added successfully.');
    } catch (e) {
      print('Error inserting transfer log: $e');
    }
  }

  Future<int?> _getIntVal(String email, String field) async {
    print('Fetch');
    try {
      final response = await _supabase
        .from('users')
        .select(field)
        .eq('email', email)
        .maybeSingle();

      if (response == null || response[field] == null) return null;
      return response[field] as int;
    } catch (e) {
      print('error in _getIntVal $e');
      return null;
    }
  }

  Future<String?> _getStringVal(String email, String field) async {
    print('Fetch');
    try {
      final response = await _supabase
        .from('users')
        .select(field)
        .eq('email', email)
        .maybeSingle();

      if (response == null || response[field] == null) return null;
      return response[field] as String;
    } catch (e) {
      print('error in _getIntVal $e');
      return null;
    }
  }

  Future<void> _updateVal(String email, String field, newValue) async {
    try {
      final _ = await _supabase
        .from('users')
        .update({field: newValue})
        .eq('email', email)
        .maybeSingle();
    } catch (e) {
      print(e);
    }
  }

  Future<void> bulkAssignScrapsWithNfc(List<String> allNfcValues, int newScrapValue) async {
    try {
    // Start a batch request to update all users with the new scrap value
      final updates = allNfcValues.map((nfc) {
        return _supabase
            .from('users')
            .update({'scraps': newScrapValue}) // Change 'scrap_value' to your desired field
            .eq('nfc_tag', nfc);
      }).toList();

      // Execute all updates simultaneously
      await Future.wait(updates);

      print('Bulk update successful!');
    } catch (e) {
      print('Error during bulk update: $e');
    }
  }


  Future<String> getScrapFromEmail(String email) async {
    int numOfScraps = await _getIntVal(email, 'scraps') ?? 0;
    return numOfScraps.toString();
  }

  Future<void> addScrapToEmail(String email, int amount) async {
    int currentScraps = int.parse(await getScrapFromEmail(email));
    _updateVal(email, 'scraps', currentScraps+amount);
  }

  Future<bool> checkNfcTagValue(String email) async {
    String? response = await _getStringVal(email, 'nfc_tag');
    if (response == null || response=='null' || response=='') {
      return false;
    }
    return true;
  }

  Future<String> getNfcTagValue(String email) async {
    return await _getStringVal(email, 'nfc_tag') ?? 'Error';
  }

  Future<void> assignNfcTagValue(String email, String nfcValue) async {
    _updateVal(email, 'nfc_tag', nfcValue);
  }

  Future<String?> getFullNameFromNFC(String nfcTag) async { // Yeah mb i was a bit lazy, the search filter already used full names so u could just save coding time by retrieving name then searching by name : instead of making a new search filter
    String field = 'full_name';
    try {
      final response = await _supabase
        .from('users')
        .select(field)
        .eq('nfc_tag', nfcTag)
        .maybeSingle();

      if (response == null || response[field] == null) return null;
      return response[field] as String;
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future<String> _getVersion() async {
    print('Fetch');
    try {
      final response = await _supabase
        .from('system_data')
        .select('current_system_version')
        .eq('id', 1)
        .maybeSingle();

      if (response == null) return 'retrieve_error';
      return response['current_system_version'] as String;
    } catch (e) {
      print(e);
      return 'retrieve_error';
    }
  }

  Future<String> generateVersionWarning() async {
    String globalVer = await _getVersion();
    if (local_system_ver == globalVer) {
      return 'Latest Version | $local_system_ver';
    } else {
      return 'Outdated Version | Update $local_system_ver -> $globalVer';
    }
  }

  // ================== Decipricated ================== //

  Future<String> readDate(String userEmail) async {
    final response = await _supabase
        .from('users')
        .select('DOB')
        .eq('email', userEmail)
        .maybeSingle();

    return response?['DOB'] ?? '';
  }

  Future<String> getEmail(String emailToVerify) async {
    final response = await _supabase
        .from('users')
        .select('email')
        .eq('email', emailToVerify)
        .maybeSingle();

    return response?['email'] ?? '';
  }
}