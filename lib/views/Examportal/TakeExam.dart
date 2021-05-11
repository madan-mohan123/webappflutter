import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep4exam/services/exam.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/Examportal/Timer.dart';

class TakeExam extends StatefulWidget {
  final String examId;
  final String examName;
  final bool admin;

  final String examDuration;
  TakeExam({
    this.examId,
    this.examName,
    this.admin,
    this.examDuration,
  });
  @override
  _TakeExamState createState() => _TakeExamState();
}

List<Map<String, dynamic>> _answerList = [];

class _TakeExamState extends State<TakeExam> {
  int ind = 0;
  int lengthd = 0;
  String _examIdforTimer = "0";
  String _timerforTimer = "0";
  ExamDatabase databaseService = new ExamDatabase();
  MyTimeForExam myTime;
  bool _isloading = false;
  AuthServices authServices = new AuthServices();
  List<Map<String, dynamic>> questionList = [];
  String _email = "";
  var lp = [];
  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        _email = value;
      });
    });
    databaseService.takeExam(widget.examId).then((value) {
      setState(() {
        _answerList.clear();
        questionList.add(value);
        lp = List<Map<String, dynamic>>.from(questionList[0]["examdata"]);
        _answerList = List<Map<String, dynamic>>.from(lp);
        lengthd = _answerList.length;
      });
    });
    _timerforTimer = widget.examDuration;
    _examIdforTimer = widget.examId;

    super.initState();
  }

  List<Map<String, dynamic>> formfieldlist = [];

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          title: Text("Exam Portal"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: !_isloading
            ? Center(
                child: Container(
                    width: ResponsiveWidget.isLargeScreen(context) ||
                            ResponsiveWidget.isMediumScreen(context)
                        ? 800
                        : null,
                    child: ListView(shrinkWrap: true, children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "Exam Name: ${widget.examName}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w500),
                          )),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "Duration: ${widget.examDuration} Min",
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.blueAccent),
                          )),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: MyTimeForExam(
                              timeInMinutes: int.parse(_timerforTimer),
                              examId: _examIdforTimer,
                              done: false)),
                      Divider(
                        height: 3.0,
                        color: Colors.grey,
                      ),
                      Container(child: Builder(builder: (context) {
                        try {
                          formfieldlist = List<Map<String, dynamic>>.from(
                              _answerList[ind]["data"]);
                          return ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        )),
                                    child: Container(
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            elevation: 10,
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 5),
                                                decoration: new BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                ),
                                                child: Row(children: [
                                                  Expanded(
                                                    child: Text(
                                                        'Section : ${_answerList[ind]["section"]}',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                  Text(
                                                      'Marks : ${_answerList[ind]["marks"]}',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white)),
                                                ]))))),
                                Container(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _answerList[ind]["data"].length,
                                        itemBuilder:
                                            (BuildContext ctxt, int index) {
                                          try {
                                            if (formfieldlist[index]
                                                .containsValue("textfield")) {
                                              return MyTextInput(
                                                  ind,
                                                  index,
                                                  formfieldlist[index]["value"],
                                                  formfieldlist[index]
                                                      ["answer"]);
                                            } else if (formfieldlist[index]
                                                .containsValue("checkbox")) {
                                              return MyFormCheckbox(
                                                  ind,
                                                  index,
                                                  List<String>.from(
                                                      formfieldlist[index]
                                                          ["value"]),
                                                  formfieldlist[index]
                                                      ["heading"]);
                                            } else {
                                              return MyFormradio(
                                                  ind,
                                                  index,
                                                  List<String>.from(
                                                      formfieldlist[index]
                                                          ["value"]),
                                                  formfieldlist[index]
                                                      ["heading"]);
                                            }
                                          } catch (e) {
                                            return Container();
                                          }
                                        })),
                                ButtonBar(children: [
                                  ind == 0
                                      ? Container()
                                      : ElevatedButton(
                                          child: Text("Previous"),
                                          onPressed: () {
                                            setState(() {
                                              ind--;
                                              if (ind <= -1) {
                                                ind = 0;
                                              }
                                            });
                                          }),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                      child: Text(ind == lengthd - 1
                                          ? "Finish"
                                          : "next"),
                                      onPressed: () async {
                                        setState(() {
                                          if (ind <= lengthd - 1) {
                                            ind++;
                                          }
                                          if (ind > lengthd - 1) {}
                                        });
                                        if (ind == lengthd) {
                                          if (widget.admin) {
                                            ShowAlertDialogs showAlertDialogs =
                                                new ShowAlertDialogs();
                                            showAlertDialogs.showAlertDialog(
                                                context,
                                                "You are Admin so Cannot submit ?");
                                          } else {
                                            submitAnswer();
                                          }
                                        }
                                      }),
                                ])
                              ]);
                        } catch (e) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      })),
                    ])))
            : Container(child: Center(child: CircularProgressIndicator())),
      );
    } catch (e) {
      return Scaffold();
    }
  }

  submitAnswer() async {
    ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
    bool _alreadysubmit = false;
    setState(() {
        _isloading = true;
      });
    await Firestore.instance
        .collection("ExamJoin")
        .where("examId", isEqualTo: widget.examId)
        .where("email", isEqualTo: _email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        if (documentSnapshot.data["submitted"] == "yes") {
          _alreadysubmit = true;
        }
      });
    })
    .catchError((e) {
        showAlertDialogs.showAlertDialog(
            context, "Your Internet Connection is slow");
        setState(() {
          _isloading = false;
        });
      });
    if (!_alreadysubmit) {
      bool submit = false;
      await Firestore.instance
          .collection("ExamJoin")
          .where("examId", isEqualTo: widget.examId)
          .where("email", isEqualTo: _email)
          .getDocuments()
          .then((value) {
        value.documents.forEach((documentSnapshot) {
          documentSnapshot.reference
              .updateData({"response": _answerList, "submitted": "yes"});
        });
        setState(() {
          _isloading = false;
          submit = true;
        });
      }).catchError((e) {
        showAlertDialogs.showAlertDialog(
            context, "Your Internet Connection is slow");
        setState(() {
          _isloading = false;
        });
      });

      if (submit) {
        MyTimeForExam(done: true);
        await showAlertDialogs.showAlertDialog(
            context, "Your Response Successfuly Submitted");
        setState(() {
          _isloading = false;
        });
        await Navigator.pushReplacementNamed(context, '/');
      }
    }
    else{
       await showAlertDialogs.showAlertDialog(
            context, "You Cannot Submit it Again ? ");
        setState(() {
          _isloading = false;
        });
    }
  }
}

class MyTextInput extends StatefulWidget {
  final int ind;
  final int index;
  final String formfieldlist;
  final String ans;

  MyTextInput(this.ind, this.index, this.formfieldlist, this.ans);
  @override
  _MyTextInputState createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  String _ans = "";
  String _formfieldlist = "";

  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ans = "";
      _ans = widget.ans;
      _formfieldlist = widget.formfieldlist;
    });

    return ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text("Q${widget.index + 1} $_formfieldlist",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 17.0)),
                    ),
                    new Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          key: Key(_ans.toString()),
                          initialValue: _ans.toString(),
                          onChanged: (text) {
                            _answerList[widget.ind]["data"][widget.index]
                                ["answer"] = text;
                          },
                        )),
                  ]))
        ]);
  }
}

class MyFormCheckbox extends StatefulWidget {
  final int ind;
  final int index;
  final String title;
  final List<String> checkboxlist;

  MyFormCheckbox(this.ind, this.index, this.checkboxlist, this.title);
  @override
  _MyFormCheckboxState createState() => _MyFormCheckboxState();
}

class _MyFormCheckboxState extends State<MyFormCheckbox> {
  List<bool> checkfalse = [];
  List<String> selectcheckbox = [];

  int ch = 0;

  @override
  void initState() {
    setState(() {
      ch = widget.ind;
      checkfalse =
          new List.filled(widget.checkboxlist.length, false, growable: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.ind != ch) {
        ch = widget.ind;
        selectcheckbox = [];
      }
    });
    try {
      return Container(
          margin: EdgeInsets.all(15),
          child: Column(children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Text("Q${widget.index + 1} ${widget.title}",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 17.0)),
            ),
            Container(
              color: Colors.white,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.checkboxlist.length,
                  itemBuilder: (BuildContext con, int indf) {
                    return CheckboxListTile(
                      title: Text("${indf + 1}. ${widget.checkboxlist[indf]}"),
                      value: _answerList[widget.ind]["data"][widget.index]
                                  ["answer"]
                              .contains(widget.checkboxlist[indf])
                          ? true
                          : false,
                      onChanged: (ch) {
                        setState(() {
                          if (checkfalse[indf]) {
                            this.checkfalse[indf] = false;
                            selectcheckbox.remove(widget.checkboxlist[indf]);

                            _answerList[widget.ind]["data"][widget.index]
                                ["answer"] = selectcheckbox;
                          } else {
                            this.checkfalse[indf] = true;

                            selectcheckbox.add(widget.checkboxlist[indf]);

                            _answerList[widget.ind]["data"][widget.index]
                                ["answer"] = selectcheckbox;
                          }
                        });
                      },
                    );
                  }),
            ),
          ]));
    } catch (e) {
      return Container();
    }
  }
}

class MyFormradio extends StatefulWidget {
  final int ind;
  final int index;
  final String title;
  final List<String> radioboxlist;

  MyFormradio(this.ind, this.index, this.radioboxlist, this.title);
  @override
  _MyFormradioState createState() => _MyFormradioState();
}

class _MyFormradioState extends State<MyFormradio> {
  String radioval = "";
  @override
  void initState() {
    super.initState();

    setState(() {
      radioval = widget.radioboxlist[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Text("Q${widget.index + 1} ${widget.title}",
                style: TextStyle(color: Colors.blueAccent, fontSize: 17.0)),
          ),
          Container(
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.radioboxlist.length,
                itemBuilder: (BuildContext con, int ind) {
                  return ListTile(
                    title: Text("${widget.radioboxlist[ind]}"),
                    leading: Radio(
                      value: widget.radioboxlist[ind].toString(),
                      groupValue: _answerList[widget.ind]["data"][widget.index]
                          ["answer"],
                      onChanged: (val) {
                        setState(() {
                          this.radioval = val.toString();

                          _answerList[widget.ind]["data"][widget.index]
                              ["answer"] = val;
                        });
                      },
                    ),
                  );
                }),
          ),
        ]));
  }
}
