import 'package:flutter/material.dart';
import 'supabase_access.dart';
import 'nfc_access.dart';
import 'bulk_assign.dart';

// Contents //
// Document images + Test data
// Individiual Widget Logic
// IW Display
// Searchbar Logic + Display

final Widget searchBarAsset = Image.asset('assets/ScrapyardSearchAssets/searchbar.png');
final Widget femaleWidget = Image.asset('assets/female2.png');
final Widget maleWidget = Image.asset('assets/male2.png');

List<List<String>> allEntries = [ // Testing data
  ['male', 'John Smith', 'jsmith@gmail.com'],
  ['male', 'Michael Brown', 'mbrown@example.com'],
  ['male', 'James Wilson', 'jwilson@email.com'],
  ['male', 'Matthew Thomflutt', 'mthomas@example.com'],
  ['female', 'Emily Johnson', 'ejohnson@email.com'],
  ['female', 'Sophia Davis', 'sophia.d@email.com'],
  ['male', 'Daniel Taylor', 'dtaylor@email.com'],
  ['female', 'Olivia Martinez', 'omartinez@example.com'],
  ['male', 'David Harris', 'dharris@example.com'],
  ['female', 'Ava White', 'ava.white@email.com'],
  ['female', 'Emma Ander', 'eanderson@email.com'],
  ['female', 'Isabella Lewis', 'ilewis@email.com'],
];

Color getColour(int alpha) {
    return Color.fromARGB(alpha, 87, 0, 142);
  }

Widget makeWidgetFromProfile(gender, String fullName, String email) {
  return SizedBox(
    width: 240, // Ratio is 4:1
    height: 60,
    child: Stack(
      children: [
        gender.toString().toLowerCase().contains('she') ? femaleWidget : maleWidget, // Base Backround
        Positioned(
          left: 60,
          top: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName.length > 16 ? '${fullName.substring(0, 16)}...' : fullName, // If more than 14 length then replace the rest with a ...
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                email.length > 34 ? '${email.substring(0, 34)}...' : email, // If more than 35 length then replace the rest with a ...
                style: TextStyle(
                  fontSize: 7,
                ),
              )
            ],
          ),
        )
      ],
    )
  );
}

List<Widget> makeScrollableDisplaySection(List<List<String>> entries) {
  List<Widget> output = [];
  for (List<String> entry in entries) {
    output.add(ClickableProfile(gender: entry[0], fullName: entry[1], email: entry[2]));
  }
  return output;
}

// Depreciated
Widget dashboardWithSearchBar() {
  return Container(
    width: 250,
    height: 400,
    color: Colors.white,
    child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: searchBarAsset,
        ),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              children: makeScrollableDisplaySection(allEntries),
            ),
          ),
        ),
      ]
    ),
  );
}

class ClickableProfile extends StatefulWidget {
  const ClickableProfile({super.key, required this.gender, required this.fullName, required this.email});
  final String gender;
  final String fullName;
  final String email;
  @override
  ClickableProfileState createState() => ClickableProfileState();
}

class ClickableProfileState extends State<ClickableProfile> {
  String displayState = 'show_profile';
  TextEditingController customScrapController = TextEditingController();
  String scrapsAmount = 'None';

  void _onPress() {
    setState(() {
      displayState = 'show_send_scrap_options';
    });
  }

  void _addScrap(int amount) async {
    await supabaseAccess.addScrapToEmail(widget.email, amount);
    setState(() {
      // Logic
    });
  }

  void _return() {
    setState(() {
      displayState = 'show_profile';
    });
  }

  void beignPair() async {
    String? nfcCode = await scanNFC();
    if (nfcCode == null) return;
    supabaseAccess.assignNfcTagValue(widget.email, nfcCode);
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {});
  }


  Widget addScrapButton(int amount) {
  return ElevatedButton(
    onPressed: () => _addScrap(amount),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221), // Red color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Square shape
      ),
      padding: EdgeInsets.zero, // No extra padding
      minimumSize: Size(50, 45), // Square dimensions
    ),
    child: Text(amount.toString()),
  );
  }

  Widget scrapShower() {
    return FutureBuilder<String>(
      future: supabaseAccess.getScrapFromEmail(widget.email), // Your future function
      builder: (context, snapshot) {
        // Check the status of the future
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 5),); // Error handling
        } else if (snapshot.hasData) {
          return Text(snapshot.data ?? '0', style: TextStyle(fontSize: 10),); // Success, display the value
        } else {
          return Text('No data', style: TextStyle(fontSize: 10),); // In case there's no data
        }
      },
    );
  }

  Widget normalScrapCounter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current # of Scraps held',
          style: TextStyle(
            fontSize: 6
          ),
        ),
        scrapShower()
      ],
    );
  }

  Widget leftMostSection() {
    return SizedBox(
      width: 40,
      child: FutureBuilder<bool>(
        future: supabaseAccess.checkNfcTagValue(widget.email), // Your future function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 40,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 5),);
          } else if (snapshot.data == true) {
            return normalScrapCounter();
          } else if (snapshot.data == false) {
            return ElevatedButton(
              onPressed: beignPair, // Call NFC
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 206, 255, 226), // Red color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Square shape
                ),
                padding: EdgeInsets.zero, // No extra padding
                minimumSize: Size(55, 55), // Square dimensions
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pair'),
                  scrapShower(),
                ]
              ),
            );
          } else {
            print('NFC Value failed to be retrieved');
            return SizedBox();
          }
        }
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 231, 231, 231),   // Border color
          width: 2.0,           // Border width
          style: BorderStyle.solid,  // Border style (solid, dotted, dashed, etc.)
        ), // Optional: Rounded corners
      ),
      child: displayState == 'show_profile' ? OutlinedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Ensures no extra padding
          padding: EdgeInsets.zero, // Removes default padding
          minimumSize: Size.zero, // Ensures no extra space
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrinks button hitbox
        ),
        onPressed: _onPress,
          child: makeWidgetFromProfile(widget.gender, widget.fullName, widget.email),
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          leftMostSection(),
          addScrapButton(10),
          addScrapButton(5), // (customScrapController.text.isNotEmpty ? int.parse(customScrapController.text) : -10)
          SizedBox(
            width: 40,
            height: 37,
            child: TextField(
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
              onSubmitted: (value) {_addScrap(int.parse(customScrapController.text));},
            ),
          ),
          ElevatedButton(
            onPressed: _return,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Red color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Square shape
              ),
              padding: EdgeInsets.zero, // No extra padding
              minimumSize: Size(55, 55), // Square dimensions
            ),
            child: Icon(Icons.close, color: Colors.white), // X symbol
          )
        ],
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<List<String>> filteredItems = [];
  List<Widget> filteredSelection = [];
  List<List<String>> defaultFullEntries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
  defaultFullEntries = await supabaseAccess.getAllEntriesFromDatabase();
  filteredItems = defaultFullEntries;
  setState(() {
    filteredSelection = makeScrollableDisplaySection(filteredItems);
  });
}

  void filterSearch(String query) {
    // Loop through all entries to filter by the search query
    setState(() {
      filteredItems = defaultFullEntries
          .where((item) => item[1].toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredSelection = makeScrollableDisplaySection(filteredItems);
    });
  }

  void scanAndUpdate() async {
    String? nfcTag = await scanNFC();
    if (nfcTag == null) return;

    String? name = await supabaseAccess.getFullNameFromNFC(nfcTag);
    if (name == null) return;

    filterSearch(name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 550,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 30,
                  color: getColour(80),
                ),
                Container(
                  width: 240,
                  height: 30,
                  color: getColour(60),
                  child: Center(
                    child: Text(
                      'Assign Scrap View',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ),
                SizedBox(
                  width: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getColour(230),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Square shape
                      ),
                      padding: EdgeInsets.zero,// No extra padding // Square dimensions
                    ),
                    child: Icon(Icons.close, color: Colors.white), // X symbol
                  )
                )
              ],
            )
          ),
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: 240,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: filterSearch,
              ),
            ),
          ),
          SizedBox(
            height: 330,
            child: SingleChildScrollView(
              child: Column(
                children: filteredSelection,
              )
            )
          ),
          SizedBox(
            height: 10
          ),
          SizedBox(
            height: 30,
            width: 240,
            child: ElevatedButton(
              onPressed: scanAndUpdate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(120, 232, 219, 251),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                //minimumSize: Size(55, 55), // Square dimensions
              ),
              child: Text('Search via NFC Tag'),
            ),
          ),
          SizedBox(height: 10,),
          BulkAssign(),
          SizedBox(height: 10,),
          SizedBox(
            height: 15,
            child: FutureBuilder<String>(
              future: supabaseAccess.generateVersionWarning(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); 
                } else if (snapshot.hasError) {
                  return Text('Error retrieving version', style: TextStyle(fontSize: 10),);
                } else if (snapshot.hasData == true) {
                  return Text(snapshot.data ?? 'err', style: TextStyle(fontSize: 10),);
                } else {
                  return Text('past_decision_err', style: TextStyle(fontSize: 10),);
                }
              },
            ),
          ),
        ],
      )
    );
  }
}

void test() async {
  final email = 'johnwickfake@gmail.com';
  String? name = await supabaseAccess.getFullNameFromNFC('{nfca: {identifier: [255, 15, 144, 184, 143, 0, 0], atqa: [68, 0], maxTransceiveLength: 253, sak: 0, timeout: 618}, ndef: {identifier: [255, 15, 144, 184, 143, 0, 0], isWritable: true, maxSize: 137, canMakeReadOnly: true, cachedMessage: {records: [{typeNameFormat: 1, type: [84], identifier: [], payload: [2, 101, 110, 98, 97, 108, 108, 115]}]}, type: org.nfcforum.ndef.type2}}');
  if (name==null) {
    supabaseAccess.addScrapToEmail(email, -1000);
    return;
  }
  if (name.contains('John')) {
    supabaseAccess.addScrapToEmail(email, 5000);
  }
}