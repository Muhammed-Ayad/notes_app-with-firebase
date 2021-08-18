import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/show_loading.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _myusername, _mypassword, _myemail;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _signUp() async {
    var formdata = _formKey.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _myemail, password: _mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("Password is to weak"))
            ..show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: "Error",
              body: Text("The account already exists for that email"))
            ..show();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(child: Image.asset("images/logo.png")),
          Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      _myusername = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please Enter UserName';
                      }
                      if (val.length < 3) {
                        return "Should be at least 3 charcters long";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "username",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onSaved: (val) {
                      _myemail = val;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please Enter Email';
                      }
                      if (val.length > 100) {
                        return "Should be at least 100 charcters long";
                      }
                      if (val.length < 5) {
                        return "Should be at least 5 charcters long";
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
                      if (val.length < 6) {
                        return "Should be at least 6 charcters long";
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
                          Text("if you have Account "),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("login");
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
                        UserCredential respones = await _signUp();
                        if (respones != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .add({
                            'username': _myusername,
                            'email': _myemail,
                          });
                          Navigator.of(context).pushReplacementNamed('home');
                        } else {
                          print('sign up Faild');
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
