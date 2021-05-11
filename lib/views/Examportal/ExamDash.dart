import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/services/exam.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/Examportal/ExamHistory.dart';
import 'package:prep4exam/views/Examportal/examConduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';

class Examdash extends StatefulWidget {
  @override
  _ExamdashState createState() => _ExamdashState();
}

class _ExamdashState extends State<Examdash> {
  String examname = "";
  DateTime examDate;
  DateTime examStartTime;
  String examDuration = "";
  String _useremail = "";
  ExamDatabase databaseService = new ExamDatabase();
  AuthServices authServices = new AuthServices();

  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        _useremail = value;
      });
    });
    super.initState();
  }

  _showDialog() {
    showDialog<String>(
      context: context,
      builder: (context) {
        return Container(
         
          child: new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: 
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                 child:Column(
                  children: <Widget>[
                   
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Exam Name', hintText: 'eg. xxxxx'),
                      onChanged: (val) {
                        if (val != "") {
                          setState(() {
                            examname = val;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Exam Duration in minutes',
                          hintText: 'eg. xxxxx'),
                      onChanged: (val) {
                        if (val != "") {
                          setState(() {
                            examDuration = val;
                          });
                        }
                      },
                    ),
                    // ),
                    SizedBox(
                      height: 10.0,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Exam date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      onDateSelected: (DateTime value) {
                       
                        examDate = value;
                      },
                    ),
                    SizedBox(height: 10),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Exam starting Time',
                      ),
                      mode: DateTimeFieldPickerMode.time,
                      autovalidateMode: AutovalidateMode.always,
                     onDateSelected: (DateTime value) {
                       
                        examStartTime = value;
                      },
                    ),
                  ],
               
            )),
            actions: <Widget>[
              new ElevatedButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    Navigator.pop(context);
                  })
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        title: Text("Exam Dashboard"),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        brightness: Brightness.light,
      
      ),
      body:Center(child:
      
            Container(
              width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? 800
                  : null,
                  child: ListView(
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              if (examname != "") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExamConduct(
                            examname, examDate, examDuration, examStartTime)));
              } else {
                _showDialog();
              }
            },
            child: Container(
                decoration: new BoxDecoration(
                  color: Colors.teal[400],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  
                  ),
                  
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      spreadRadius: 1.0,
                    ), 
                  ],
                ),
                height: 200,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),

               child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image.network(
            'https://images.unsplash.com/photo-1558021212-51b6ecfa0db9?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8c3R1ZHl8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
            alignment: Alignment.center,
            child: Text(
              'Conduct Exam',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,),
            )),
      ],
    ),
               
                ),
          ),
          GestureDetector(
            onTap: () {
              _joinExam();
            },
            child: Container(
                decoration: new BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      spreadRadius: 1.0,
                    ), //BoxShadow
                  ],
                ),
                height: 200,
//                color:Colors.white,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                     child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          
          child: Image.network(
            'https://media2.vault.com/14338501/alphabet-blur-books-close-up-301920-1.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
            alignment: Alignment.center,
            child: Text(
              'Join Exam',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,),
            )),
      ],
    ),
                ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExamHistory(_useremail)));
              },
              child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan,
                        offset: const Offset(
                          0.0,
                          0.0,
                        ),
                        spreadRadius: 1.0,
                      ), //BoxShadow
                    ],
                  ),
                  height: 200,
//                color:Colors.white,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                       child: Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image.network(
            'https://previews.123rf.com/images/diignat/diignat1808/diignat180800038/105835321-attractive-smiling-students-having-fun-outdoors-on-campus-at-the-university-beautiful-college-girls-.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
            alignment: Alignment.center,
            child: Text(
              'History',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,),
            )),
      ],
    ),
                  
                  )),
        ],
      ))
      ),
    );
  }

  String joinexamid = "";
  _joinExam() {
    showDialog<String>(
        context: context,
        builder: (context) {
          return Container(
              child: new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Exam Id', hintText: 'eg. xxxxx'),
                    onChanged: (val) {
                      if (val != "") {
                        setState(() {
                          joinexamid = val;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new ElevatedButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    try {
                      var checkid = await Firestore.instance
                          .collection("Exams")
                          .where('examid', isEqualTo: joinexamid)
                          .getDocuments();

                      if (checkid.documents.isNotEmpty) {
                        bool alreadyexist = false;

                        await Firestore.instance
                            .collection("ExamJoin")
                            .where("email", isEqualTo: _useremail)
                            .where("examId", isEqualTo: joinexamid)
                            .getDocuments()
                            .then((value) {
                          value.documents.forEach((documentSnapshot) {
                            if (documentSnapshot.exists) {
                              setState(() {
                                alreadyexist = true;
                              });
                            }
                          });
                        });
                        if (!alreadyexist) {
                          ShowAlertDialogs showAlertDialogs =
                              new ShowAlertDialogs();
                          Map<String, dynamic> examData = {
                            "examId": joinexamid,
                            "email": _useremail,
                            "response": {},
                            "submitted": "no"
                          };
                          await databaseService
                              .joinExam(examData)
                              .then((value) {
                            showAlertDialogs.showAlertDialog(
                                context, "success fully Joined");
                            Navigator.pop(context);
                          }).catchError((e) {
                            showAlertDialogs.showAlertDialog(
                                context, "Slow Internet connection");
                          });
                        } else {
                          showDialogForWrongId(context, "Already Join");
                        }
                      } else {
                        showDialogForWrongId(context, "Invalid Exam Id");
                      }
                    } catch (e) {
                     
                      showDialogForWrongId(context, "Slow Internet connection");
                    }
                  })
            ],
          ));
        });
  }

  showDialogForWrongId(BuildContext context, String msg) {
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oops"),
      content: Text(msg),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
