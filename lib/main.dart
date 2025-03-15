import 'package:flutter/material.dart';
import 'scrap_assign_page.dart'; 

import 'supabase_access.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dob.dart';

String? activeEmail;
final forrestGreen = Color.fromARGB(255, 26, 65, 50);

String _logWarning = '';
String displayName = 'Loading...';

// --------- Document Settings --------- //

final Color widgetMainColor = Color.fromARGB(255, 255, 255, 255);
final ButtonStyle mainButtonStyling = ElevatedButton.styleFrom(
  minimumSize: Size(double.infinity, 50),
  backgroundColor: const Color.fromARGB(255, 233, 226, 253),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5)
  ),
);
final ButtonStyle mediumButtonStyling = ElevatedButton.styleFrom(
  minimumSize: Size(double.infinity, 50),
  backgroundColor: forrestGreen,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0)
  ),
);
final TextStyle h1 = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.underline,
);
final EdgeInsets defaultContainerPadding = EdgeInsets.only(
  top: 50,
  left: 45, 
  right: 45,
  bottom: 50, 
);

const supabaseUrl = 'https://jbquklcpvvqnjdrxvexl.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpicXVrbGNwdnZxbmpkcnh2ZXhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3Nzg4MjIsImV4cCI6MjA1NzM1NDgyMn0.yd-Q4Shsg-yVKhNfQQPuDwIvcchvwQLK4dC-m5wKv0g';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  int stateForcer = 0;
  // --------- Page Element Controllers --------- //

  final TextEditingController _emailController = TextEditingController();

  // ================== TAB SWITCHING ================== //

  void redirectToSignUpPage() {
    setState(() {
      // Redirect to sign-up page
    });
  }

  void resetActiveEmail() {
    setState(() {
      activeEmail = null;
      isDobValidated = false;
    });
  }

  void returnToDOB() {
    setState(() {
      isDobValidated = false;
    });
  }

  void enforeState() {
    setState(() {
      stateForcer++;
    });
  }

  // ================== Sign-in Methods ================== //

  @override
  void initState() {
    super.initState();
  }

  Future<void> _call() async {
    try {
      String newEmail = _emailController.text.trim();
      activeEmail = await supabaseAccess.getEmail(newEmail);
      supabaseAccess.setSelectedEmail(activeEmail);
      setState(() {});
    } catch (e) {
      setState(() {
        _logWarning = "Email not recognised";
      });
      print("Error: $e");
    }
  }

  // ================== PAGES ================== //

  Widget generateSignInPage() {
    return Container(
      width: 393.4,
      height: 356,
      padding: defaultContainerPadding,
      color: widgetMainColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Onboard NFC Tag",
            style: h1,
          ),
          SizedBox(height: 0,),
          TextField(
            controller: _emailController, 
            decoration: InputDecoration(
              labelText: "Email*",
              labelStyle: TextStyle(color: Colors.grey, fontSize: 16), // Label text style
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: forrestGreen, width: 2.0), // Green underline when focused
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: forrestGreen, width: 1.5), // Green underline when not focused
              ),
              ),
            style: TextStyle(color: forrestGreen, fontSize: 16, fontWeight: FontWeight.bold), // Input text style
            cursorColor: forrestGreen,
          ),
          //TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
          SizedBox(
            height: 20,
            child: Text(_logWarning,
              style: TextStyle(
                fontSize: 10,
                color: Colors.pink,
              )
            ),
          ),
          Text('*Please enter the email that you used in the registration form'),
          //ElevatedButton(onPressed: signInWithGoogle, style: mainButtonStyling, child: Text("Sign In with Google"), ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: _call, 
            style: mediumButtonStyling,
            child: Text("Next",
              style: TextStyle(
                color: Colors.white
              ),
            )
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Haven't filled out the application? "),
              TextButton(
              onPressed: redirectToSignUpPage,
              style: TextButton.styleFrom(
                padding: EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                  left: 10,
                  right: 10,
                ),
                minimumSize: Size(0, 0),  // Remove minimum button constraints
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
              ),
              child: Text('Click here!',
                style: TextStyle(
                  color: const Color.fromARGB(255, 157, 76, 224),
                  decoration: TextDecoration.underline,
                )
              ),
            ),
          ]),
        ],
      )
    );
  }

  // ================== MAIN ================== //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //appBar: AppBar(title: Text('Skeleton Firebase Test')),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Hack_Club_Assemble_LTNJ_00622_Large_ysbchr.jpg'),
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: SizedBox( 
                  width: 400,
                  child: FittedBox(child: 
                    SearchScreen(),
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}