import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/show_loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _mypassword, _myemail;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _signIn() async {
    var formdata = _formKey.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _myemail, password: _mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("No user found for that Email"))
            ..show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Wrong password provided for that user"))
            ..show();
        }
      }
    } else {
      print("Not Vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Image.asset("images/logo.png"),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      _myemail = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please Enter Email';
                      }
                      if (val.length < 3) {
                        return "Should be at least 3 charcters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onSaved: (val) {
                      _mypassword = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please Enter password';
                      }
                      if (val.length > 100) {
                        return "Should be at least 100 charcters long";
                      }
                      if (val.length < 5) {
                        return "Should be at least 5 charcters long";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "password",
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text("if you havan't accout "),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("signup");
                            },
                            child: Text(
                              "Click Here",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      )),
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        var user = await _signIn();
                        if (user != null) {
                          Navigator.of(context).pushReplacementNamed("home");
                        }
                      },
                      child: Text(
                        "Sign in",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
