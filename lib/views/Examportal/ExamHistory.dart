import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/exam.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/Examportal/CopyList.dart';
import 'package:prep4exam/views/Examportal/ExamDash.dart';
import 'package:prep4exam/views/Examportal/ParticipantInexam.dart';
import 'package:prep4exam/views/Examportal/TakeExam.dart';
import 'package:date_field/date_field.dart';

class ExamHistory extends StatefulWidget {
  final String email;
  ExamHistory(this.email);
  @override
  _ExamHistoryState createState() => _ExamHistoryState();
}

class _ExamHistoryState extends State<ExamHistory> {
  ExamDatabase databaseService = new ExamDatabase();
  Stream examsCreated;
  List<String> joinexamids;
  String _selectoptionforshowexam = "MyExams";
  @override
  void initState() {
    databaseService.showcreatedExam().then((val) {
      setState(() {
        examsCreated = val;
      });
    });

    databaseService.getjoinexamIds().then((value) {
      setState(() {
        joinexamids = value;
      });
    });
    super.initState();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Assigned':
        setState(() {
          _selectoptionforshowexam = "Assigned";
        });

        break;
      case 'MyExams':
        setState(() {
          _selectoptionforshowexam = "MyExams";
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
          title: _selectoptionforshowexam == "Assigned"
              ? Text("Joined Exams")
              : Text("Created Exams"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Assigned', 'MyExams'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      body: (_selectoptionforshowexam == "MyExams")
          ? showcreatedExamlist()
          : showassignedExamlist(),
    );
  }

  Widget showcreatedExamlist() {
    return Center(
            child: Container(
              width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? 800
                  : null,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: examsCreated,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              :ListView.builder(
                
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      if (snapshot.data.documents[index].data["email"] ==
                          widget.email) {
                        return CreatedExams(
                          examId: snapshot.data.documents[index].data["examid"],
                          examName:
                              snapshot.data.documents[index].data["examname"],
                          examDate: snapshot
                              .data.documents[index].data["examDate"]
                              .toDate(),
                          examStartTime: snapshot
                              .data.documents[index].data["examstartTime"]
                              .toDate(),
                          examDuration: snapshot
                              .data.documents[index].data["examDuration"],
                        );
                      } else {
                        return Container();
                      }
                    } catch (e) {
                      return Container();
                    }
                  },
                );
        },
      ),
    ));
  }

  Widget showassignedExamlist() {
    return Center(
            child: Container(
              width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? 800
                  : null,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: examsCreated,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
               
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      if (joinexamids.contains(
                          snapshot.data.documents[index].data["examid"])) {
                        return AssignedExams(
                          examId: snapshot.data.documents[index].data["examid"],
                          examName:
                              snapshot.data.documents[index].data["examname"],
                          examDate: snapshot
                              .data.documents[index].data["examDate"]
                              .toDate(),
                          examStartTime: snapshot
                              .data.documents[index].data["examstartTime"]
                              .toDate(),
                          examDuration: snapshot
                              .data.documents[index].data["examDuration"],
                        );
                      } else {
                        return Container();
                      }
                    } catch (e) {
                      return Container();
                    }
                  },
                );
        },
      ),
    ));
  }
}

class CreatedExams extends StatefulWidget {
  final String examId;
  final String examName;
  final String examDuration;
  final DateTime examDate;
  final DateTime examStartTime;
  CreatedExams(
      {this.examId,
      this.examName,
      this.examDate,
      this.examStartTime,
      this.examDuration});
  @override
  _CreatedExamsState createState() => _CreatedExamsState();
}

class _CreatedExamsState extends State<CreatedExams> {
  Widget indicator() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  int hours = 0;
  int minutes = 0;
  String myhours = "";
  String myminutes = "";
  String mydate = "";

  @override
  void initState() {
    setState(() {
      hours = int.parse(widget.examStartTime.hour.toString());
      minutes = int.parse(widget.examStartTime.minute.toString());

      if (minutes < 10) {
        myminutes = "0" + minutes.toString();
      } else {
        myminutes = minutes.toString();
      }
      if (hours > 12) {
        hours = hours - 12;
        if (hours.toString().length == 1) {
          myhours = "0" + hours.toString();
          mydate = myhours + " : " + myminutes + " PM";
        } else {
          myhours = hours.toString();
          mydate = myhours + " : " + myminutes + " PM";
        }
      } else {
        if (hours.toString().length == 1) {
          myhours = "0" + hours.toString();
          mydate = myhours + " : " + myminutes + " AM";
        } else {
          myhours = hours.toString();
          mydate = myhours + " : " + myminutes + " AM";
        }
      }
    });
    super.initState();
  }

  bool isload = true;
  showAlertForDeleteExam(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () async {
        isload ? indicator() : Container();
        await Firestore.instance
            .collection("Exams")
            .where('examid', isEqualTo: widget.examId)
            .getDocuments()
            .then((value) {
          value.documents.forEach((documentSnapshot) {
            documentSnapshot.reference.delete();
            setState(() {
              isload = false;
            });
          });
        }).catchError((e) {});

        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning",
        style: TextStyle(color: Colors.red),
      ),
      content: Text("Would you like to Delete this Exam ${widget.examId}"),
      actions: [
        cancelButton,
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

  Examdash examdash = new Examdash();
  String examName = "";
  String examDuration = "";
  DateTime examDate;
  DateTime examStartTime;

  _showDialogForEditInfo() {
    bool check = false;
    showDialog<String>(
      context: context,
      builder: (context) {
        return Container(
          child: new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:Column(
            
              children: [
                Column(
                  children: <Widget>[
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Exam Name', hintText: 'eg. xxxxx'),
                      onChanged: (val) {
                        if (val != "") {
                          setState(() {
                            examName = val;
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
                )
              ]),
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
                    ExamDatabase databaseService = new ExamDatabase();
                    await databaseService
                        .editExamInfo(widget.examId, examName, examDuration,
                            examDate, examStartTime)
                        .then((val) {
                      setState(() {
                        check = true;
                      });
                    });
                    if (check) {
                      ShowAlertDialogs showAlertDialogs =
                          new ShowAlertDialogs();
                      await showAlertDialogs.showAlertDialog(
                          context, "Submitted");
                      Navigator.pop(context);
                    }
                  })
            ],
          ),
        );
      },
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Participants':
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ParticipantInExam(widget.examId)));
        });

        break;
      case 'Edit':
        _showDialogForEditInfo();

        break;
      case 'Copies':
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CopyList(widget.examId)));
        });

        break;
        case 'Copy ID':
        Clipboard.setData(new ClipboardData(text: "ID :  " + widget.examId));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        child: GestureDetector(
          onDoubleTap: () {
            showAlertForDeleteExam(context);
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakeExam(
                          examId: widget.examId,
                          examName: widget.examName,
                          admin: true,
                          examDuration: widget.examDuration,
                        )));
          },
          child: Container(
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.all(6.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.shade50,
                    offset: const Offset(
                      1.0,
                      1.0,
                    ),
                    blurRadius: 0.0,
                    spreadRadius: 1.0,
                  ), //BoxShadow
                  //                     //BoxShadow
                ],
              ),
              child: Container(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigo[400],
                    elevation: 10,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 5.0,
                          ),
                          ListTile(
                            title: Text(
                              widget.examId,
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.white),
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: handleClick,
                              itemBuilder: (BuildContext context) {
                                return {'Participants', 'Edit', 'Copies','Copy ID'}
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              widget.examName,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              "ExamDuration: ${widget.examDuration} Min",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              "ExamDate: ${widget.examDate.day.toString()}-${widget.examDate.month.toString()}-${widget.examDate.year.toString()}",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            child: Text(
                              mydate,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                    )),
              )),
        ),
      );
    } catch (e) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class AssignedExams extends StatefulWidget {
  final String examId;
  final String examName;
  final String examDuration;
  final DateTime examDate;
  final DateTime examStartTime;
  AssignedExams(
      {this.examId,
      this.examName,
      this.examDate,
      this.examStartTime,
      this.examDuration});

  @override
  _AssignedExamsState createState() => _AssignedExamsState();
}

class _AssignedExamsState extends State<AssignedExams> {
  int hours = 0;
  int minutes = 0;
  String myhours = "";
  String myminutes = "";
  String mydate = "";

  @override
  void initState() {
    setState(() {
      hours = int.parse(widget.examStartTime.hour.toString());
      minutes = int.parse(widget.examStartTime.minute.toString());

      if (minutes < 10) {
        myminutes = "0" + minutes.toString();
      } else {
        myminutes = minutes.toString();
      }
      if (hours > 12) {
        hours = hours - 12;
        if (hours.toString().length == 1) {
          myhours = "0" + hours.toString();
          mydate = myhours + " : " + myminutes + " PM";
        } else {
          myhours = hours.toString();
          mydate = myhours + " : " + myminutes + " PM";
        }
      } else {
        if (hours.toString().length == 1) {
          myhours = "0" + hours.toString();
          mydate = myhours + " : " + myminutes + " AM";
        } else {
          myhours = hours.toString();
          mydate = myhours + " : " + myminutes + " AM";
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onTap: () {
        DateTime currentTimedate = new DateTime.now();
        DateTime examdate = widget.examDate;
        DateTime starttime = widget.examStartTime;
        DateTime currexamstarttime = new DateTime.now();
        if (examdate.difference(currentTimedate).inDays <= 0) {
          if ((((starttime.hour * 60) + starttime.minute) -
                  ((currexamstarttime.hour * 60) + currexamstarttime.minute) <=
              0)) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakeExam(
                          examId: widget.examId,
                          examName: widget.examName,
                          admin: false,
                          examDuration: widget.examDuration,
                        )));
          } 
          else {
            ShowAlertDialogs ob = new ShowAlertDialogs();
            ob.showAlertDialog(context, "Exam is Not start Now By Admin");
          }
        } else {
          ShowAlertDialogs ob = new ShowAlertDialogs();
          ob.showAlertDialog(context, "Exam is Not start Now By Admin");
        }
      },
      child: Container(
          padding: EdgeInsets.all(6.0),
          margin: EdgeInsets.all(6.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.shade50,
                offset: const Offset(
                  1.0,
                  1.0,
                ),
                blurRadius: 0.0,
                spreadRadius: 1.0,
              ), //BoxShadow
              //                     //BoxShadow
            ],
          ),
          child: Container(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.red[800],
                elevation: 10,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "Subject: ${widget.examName}",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "ExamDuration: ${widget.examDuration} Min",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "ExamDate: ${widget.examDate.day.toString()}-${widget.examDate.month.toString()}-${widget.examDate.year.toString()}",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(6, 3, 6, 6),
                        child: Text(
                          mydate,
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )),
          )),
    ));
  }
}
