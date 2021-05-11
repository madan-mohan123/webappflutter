import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/authentication/signin.dart';
import 'package:prep4exam/views/authentication/signup.dart';
import 'package:prep4exam/views/dashboard.dart';
import 'package:prep4exam/views/quiz/play_quiz.dart';

class HomePage extends StatefulWidget {
  final bool loggedIn;
  HomePage({this.loggedIn});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthServices authServices = new AuthServices();
  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    AuthServices authServices = new AuthServices();
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: ResponsiveWidget.isSmallScreen(context)
          ? AppBar(
              // for smaller screen sizes
              backgroundColor: Colors.deepPurple[600],
              elevation: 0,
              title: Text(
                'PREP4EXAMS',
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
            )
          : AppBar(
              // for smaller screen sizes
              backgroundColor: Colors.deepPurple[600],
              elevation: 0,
              title: Text(
                'PREP4EXAMS',
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
            ),

      drawer: Drawer(
        child: Container(
          color: Colors.blueGrey[800],
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  "PEPR4EXAM",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[200],
                      fontSize: 30),
                ),
                leading: Icon(
                  Icons.explicit_sharp,
                  color: Colors.blue[200],
                  size: 30,
                ),
              ),
              Divider(
                height: 4,
                color: Colors.grey,
              ),
              widget.loggedIn
                  ? ListTile(
                      title: Text(
                        "Dashboard",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      leading:
                          Icon(Icons.login_sharp, color: Colors.orangeAccent),
                      onTap: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      },
                    )
                  : ListTile(
                      title: Text(
                        "SignIn",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      leading: Icon(Icons.login, color: Colors.red),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signin()));
                      },
                    ),
              widget.loggedIn
                  ? ListTile(
                      title: Text(
                        "LogOut",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      leading:
                          Icon(Icons.login_sharp, color: Colors.orangeAccent),
                      onTap: () async {
                        HelperFunction.clearStorage();
                        await authServices.signOut();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signin()));
                      },
                    )
                  : ListTile(
                      title: Text(
                        "SignUp",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      leading:
                          Icon(Icons.login_sharp, color: Colors.orangeAccent),
                      onTap: () async {
                        HelperFunction.clearStorage();
                        await authServices.signOut();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                    ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Stack(children: [
            Container(
              // image below the top bar
              child: SizedBox(
                height: ResponsiveWidget.isLargeScreen(context) ||
                        ResponsiveWidget.isMediumScreen(context)
                    ? screenSize.height * 0.6
                    : 300,
                width: screenSize.width,
                child: Image.asset(
                  'assets/images/c3.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Quizzes',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await authServices.getcurrentuser().then((value) {
                              if (value != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayQuiz(
                                              quizId: "ROooLEsD",
                                              notauth: true,
                                              time: 5,
                                            )));
                              } else {
                                showAlertDialogs.showAlertDialog(
                                    context, "Please LogIn");
                              }
                            });
                          },
                          child: SizedBox(
                            height: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 6
                                : 200,
                            width: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 3.8
                                : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.asset(
                                'assets/images/q1.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'Maths',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                              await authServices.getcurrentuser().then((value) {
                              if (value != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayQuiz(
                                              quizId: "cD525378",
                                              notauth: true,
                                              time: 5,
                                            )));
                              } else {
                                showAlertDialogs.showAlertDialog(
                                    context, "Please LogIn");
                              }
                            });
                          },
                          child: SizedBox(
                            height: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 6
                                : 200,
                            width: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 3.8
                                : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.asset(
                                'assets/images/q2.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async{
                           
                                 await authServices.getcurrentuser().then((value){
                              if (value != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayQuiz(
                                              quizId: "ROooLEsD",
                                              notauth: true,
                                              time: 5,
                                            )));
                              } else {
                                showAlertDialogs.showAlertDialog(
                                    context, "Please LogIn");
                              }
                            });
                          },
                          child: SizedBox(
                            height: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 6
                                : 200,
                            width: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 3.8
                                : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.asset(
                                'assets/images/q3.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                             await authServices.getcurrentuser().then((value) {
                              if (value != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayQuiz(
                                              quizId: "cD525378",
                                              notauth: true,
                                              time: 5,
                                            )));
                              } else {
                                showAlertDialogs.showAlertDialog(
                                    context, "Please LogIn");
                              }
                            });
                          },
                          child: SizedBox(
                            height: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 6
                                : 200,
                            width: ResponsiveWidget.isLargeScreen(context) ||
                                    ResponsiveWidget.isMediumScreen(context)
                                ? screenSize.width / 3.8
                                : null,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.asset(
                                'assets/images/q4.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'IoT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Forms',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 6
                              : 200,
                          width: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 3.8
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              'assets/images/f1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'Feedback Form',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 6
                              : 200,
                          width: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 3.8
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              'assets/images/f2.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 6
                              : 200,
                          width: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 3.8
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              'assets/images/f3.jfif',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'Query',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 6
                              : 200,
                          width: ResponsiveWidget.isLargeScreen(context) ||
                                  ResponsiveWidget.isMediumScreen(context)
                              ? screenSize.width / 3.8
                              : null,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              'assets/images/q2.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenSize.height / 70,
                          ),
                          child: Text(
                            'Education Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
