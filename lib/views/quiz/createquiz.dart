import 'package:flutter/material.dart';

import 'package:prep4exam/services/quiz.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/quiz/addquestion.dart';
import 'package:random_string/random_string.dart';
import 'package:prep4exam/services/auth.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageUrl, quizTitle, quizDescription, quizId;
  Quizdatabase databaseService = new Quizdatabase();
  AuthServices authServices = new AuthServices();
  int timer;
  String _useremail = "";
  bool _isLoading = false;

  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        _useremail = value;
      });
    });
    super.initState();
  }

  createQuizOnline() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      quizId = randomAlphaNumeric(8);
      DateTime currentTime = DateTime.now();
          String cdt = currentTime.day.toString() + " : " +
              currentTime.month.toString() + " : " + 
              currentTime.year.toString();
      Map<String, dynamic> quizMap = {
        "quizId": quizId,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription,
        "email": _useremail,
        "flag": false,
        "timer": timer,
        "blacklist":[],
        "date":cdt
      };
      await databaseService.addQuizData(quizMap, quizId).then((val) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
        });
      }).catchError((e) {
        createQuizOnline();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black87),
          brightness: Brightness.light,
         
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center(
        child: Container(
          alignment: Alignment.topLeft,
      width: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 800
          : null,
           child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [

                Container(
              
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                       
                         padding: EdgeInsets.symmetric(horizontal: 24),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                     child: Text("Enter the Quiz Details ?",style: TextStyle(fontSize: 20),),
                      ),

                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Quiz Title Required" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Title ",
                        ),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        validator: (val) =>
                            val.isEmpty ? "Description Required" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Description ",
                        ),
                        onChanged: (val) {
                          //
                          quizDescription = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Timer Required " : val.contains(new RegExp('[a-zA-Z.]')) ? "It should be Number" : null,
                        decoration: InputDecoration(
                          hintText: "Timer in minutes ",
                        ),
                        onChanged: (val) {
                          if (!val.contains(".")) {
                            timer = int.parse(val);
                          }
                        },
                      ),
                       SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                          onTap: () {
                            createQuizOnline();
                          },
                          child: blueButton(
                            context: context,
                            label: " Create Quiz",
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
                ],)))));
  }
}
