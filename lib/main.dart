import 'package:flutter/material.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/views/Examportal/ExamDash.dart';
import 'package:prep4exam/views/Homepage.dart';
import 'package:prep4exam/views/dashboard.dart';
import 'package:prep4exam/views/feedbackmodule/formdash.dart';
import 'package:prep4exam/views/poll/polldashboard.dart';
import 'package:prep4exam/views/quiz/quizHome.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    checkUserLoggedInstatus();
    super.initState();
  }

  checkUserLoggedInstatus() async {
    HelperFunction.getUserLoggedInDetails().then((value) {
      setState(() {
        _isLoggedIn = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) =>  (_isLoggedIn ?? false) ? Dashboard() : HomePage(loggedIn:false),
        '/Quiz': (context) => Home(),
        '/Form':(context)=>FormDash(),
        '/Poll':(context)=>PollDashboard(),
        '/Exam':(context)=>Examdash(),
        
      },
      title: 'Prep4Exams',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
