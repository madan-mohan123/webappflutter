import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/authentication/forget.dart';
import 'package:prep4exam/views/authentication/signin.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/widgets/widgets.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String email, password, name;
  bool _isLoading = false;
  AuthServices authServices = new AuthServices();
  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

  

  @override
  Widget build(BuildContext context) {
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
            : Center(
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
                          color: Colors.amber[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo[50],
                              offset: const Offset(
                                0.0,
                                0.0,
                              ),
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ), //BoxShadow
                            //                     //BoxShadow
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
                                            ? "Enter Name ? "
                                            : null;
                                      },
                                      decoration:
                                          InputDecoration(hintText: "Username"),
                                      onChanged: (val) {
                                        name = val;
                                      },
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    TextFormField(
                                      validator: (val) {
                                        return val.isEmpty
                                            ? "Enter correct email"
                                            : null;
                                      },
                                      decoration:
                                          InputDecoration(hintText: "Email"),
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
                                      decoration:
                                          InputDecoration(hintText: "Password"),
                                      onChanged: (val) {
                                        password = val;
                                      },
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    //  for sign in button
                                    GestureDetector(
                                      onTap: () {
                                        //funtion
                                        signUp();
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
                      color: Colors.cyan,
                      elevation: 10,
                      child: Center(
                            child:Container(
                             padding: EdgeInsets.all(10),
                             child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                         
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
                                          "Have an account ? ",
                                          style: TextStyle(fontSize: 15.5),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //funtion
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Signin()));
                                          },
                                          child: Text(
                                            "Sign in",
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
                                  ],
                                ),
                              ),
                            ))))));
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      authServices
          .signUpWithEmailAndPassword(email, password, name)
          .then((val) async {
        if (val == "true") {
          await showAlertDialogs.showAlertDialog(
              context, "Verifacation link Send on Your Email");
          await Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Signin()));
        } 
        else {
          await showAlertDialogs.showAlertDialog(
              context, "Invalid Email Address");
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((e) {
      
        showAlertDialogs.showAlertDialog(context, "Something went wrong");
      });
    }
  }
}
