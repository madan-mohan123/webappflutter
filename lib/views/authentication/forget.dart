import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/authentication/signin.dart';
// import 'package:prep4exam/views/dashboard.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/authentication/signup.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthServices authServices = new AuthServices();
  HelperFunction helperFunction = new HelperFunction();
  bool _isLoading = false;

  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
 
  forget() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices.forgetpassword(email).then((val) async{
        if (val) {
          setState(() {
            _isLoading = false;
          });
         await showAlertDialogs.showAlertDialog(context, "Password Reset Link Send on your Email");
         await Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Signin()));
        }
        else{
          setState(() {
             _isLoading = false;
          });
          await showAlertDialogs.showAlertDialog(context, "Something went wrong");
         } 
       
      }).catchError((e) {
          setState(() {
             _isLoading = false;
          });
         showAlertDialogs.showAlertDialog(context, "Something went wrong");
       
      });
    }
  }

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
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple,
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
                                        height: 12,
                                      ),

                                     


                                      //  for sign in button
                                      GestureDetector(
                                        onTap: () {
                                          forget();
                                        },
                                        child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(6, 5, 10, 6),
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
                      color: Colors.green,
                      elevation: 10,
                      child: Center(
                            child:Container(
                             padding: EdgeInsets.all(6),
                             child: Text("Reset PassWord",style: TextStyle(color: Colors.white),),
                         
                           )
                          ),
                        ))
                          
                          ),
                                      ),
                                      SizedBox(
                                        height: 18,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Dont have an account ? ",
                                            style: TextStyle(fontSize: 15.5),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              //funtion
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
}
