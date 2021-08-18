import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../auth/login.dart';
import '../auth/signup.dart';
import '../helper/add_notes.dart';
import '../screens/home_page.dart';

var isLogin;

void main(context) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primaryColor: Colors.teal,
        buttonColor: Colors.teal[100],
        textTheme: TextTheme(
          headline3: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 20, color: Colors.white),
          headline5: TextStyle(fontSize: 30, color: Colors.blue),
          bodyText2: TextStyle(fontSize: 20, color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xfff2f9fe),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      home: isLogin ? HomePage() : Login(),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => SignUp(),
        "home": (context) => HomePage(),
        "AddNotes": (context) => AddNotes(),
      },
    );
  }
}
