import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/authentication/forget.dart';
import 'package:prep4exam/views/dashboard.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/authentication/signup.dart';

class Signin extends StatefulWidget {
  @override
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthServices authServices = new AuthServices();
  HelperFunction helperFunction = new HelperFunction();
  bool _isLoading = false;
  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
          appBar: AppBar(
            title: appBar(context),
            backgroundColor: Colors.blueAccent,
            elevation: 0.0,
            brightness: Brightness.light,
          ),
          body: _isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              :  Center(
                  child: 
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                         
                          width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? 400
                  : null,
                        
                          decoration: new BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo[50],
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                              ), //BoxShadow
                            ],
                          ),
                          child: Form(
                              key: _formKey,
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  margin: EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                       
                                        height: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                              'assets/images/quiz.jpg',
                              fit: BoxFit.cover,
                            )
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        validator: (val) {
                                          return val.isEmpty
                                              ? "Enter correct email"
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Enter Email"),
                                        onChanged: (val) {
                                          email = val;
                                        },
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        validator: (val) {
                                          return val.isEmpty
                                              ? "Enter correct password"
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Enter Password"),
                                        onChanged: (val) {
                                          password = val;
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          signin();
                                        },
                                                       child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10),
                             boxShadow: [
                    BoxShadow(
                      color: Colors.cyan,
                      
                      spreadRadius: 1.0,
                    ),
                  ], 
                            ),

                           child: Container(
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.blueGrey[700],
                      elevation: 10,
                      child: Center(
                            child:Container(
                             padding: EdgeInsets.all(10),
                             child: Text("Sign In",style: TextStyle(color: Colors.white),),
                         
                           )
                          ),
                        ))
                          
                          )
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Haven't account ? ",
                                            style: TextStyle(fontSize: 15.5),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Signup()));
                                            },
                                            child: Text(
                                              "Sign up",
                                              style: TextStyle(
                                                  fontSize: 15.5,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Forget()));
                                        },
                                        child: Text(
                                          "Forget Password",
                                          style: TextStyle(
                                              fontSize: 15.5,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      // GestureDetector(
                                      //     onTap: () async{
                                      //       await authServices.signinWithGoogle();
                                      //     },
                                      //     child:
                                      //         Container(child: Text("Google")))
                                    ],
                                  ),
                                ),
                              ))))));
    } catch (e) {
      return Scaffold(
          body: Container(
        child: Center(child: CircularProgressIndicator()),
      ));
    }
  }

  signin() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices.signInEmailAndPass(email, password).then((val) async {
        if (val == "true") {
          setState(() {
            _isLoading = false;
          });

          HelperFunction.saveUserLoggedInDetails(
              isLoggedin: true, email: email);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else if (val == "false") {
          await showAlertDialogs.showAlertDialog(
              context, "Please Verify Your EMail");
          setState(() {
            _isLoading = false;
          });
        } else {
          await showAlertDialogs.showAlertDialog(
              context, "Invalid Credentials");
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((e) {
        showAlertDialogs.showAlertDialog(context, "Some thing went wrong");
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
