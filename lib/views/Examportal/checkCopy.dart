import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/services/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prep4exam/views/Breakpoints.dart';


class CheckCopy extends StatefulWidget {
  final String examId;
  final String examName;
  final bool admin;
  final String examDuration;
  final String candidateEmail;
  final List<Map<String, dynamic>> examData;

  CheckCopy(
      {this.examId,
      this.examName,
      this.admin,
      this.examDuration,
      this.candidateEmail,
      this.examData});
  @override
  _CheckCopyState createState() => _CheckCopyState();
}

List<Map<String, dynamic>> _answerList = [];

class _CheckCopyState extends State<CheckCopy> {
  int ind = 0;
  int lengthd = 0;

  ProfileDatabase databaseService = new ProfileDatabase();
  AuthServices authServices = new AuthServices();
  List<Map<String, dynamic>> questionList = [];
  var lp = [];

  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {});
    });
    setState(() {
      _answerList.clear();
      _answerList = widget.examData;
      lengthd = _answerList.length;
    });

    super.initState();
  }

  List<Map<String, dynamic>> formfieldlist = [];

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          title: Text("Exam Copies"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: Center(
            child: Container(
                width: ResponsiveWidget.isLargeScreen(context) ||
                        ResponsiveWidget.isMediumScreen(context)
                    ? 800
                    : null,
                child: ListView(shrinkWrap: true, children: [
                  Container(child: Builder(builder: (context) {
                    List<String> _locations = [];

                    double mr = 0;
                    double total = double.parse(_answerList[ind]["marks"]);
                    while (total >= mr) {
                      _locations.add(mr.toString());
                      mr = mr + 0.5;
                    }
                    _locations.add("N/A");
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
                                            padding:
                                                EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            decoration: new BoxDecoration(
                                              color: Colors.deepPurpleAccent,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Row(children: [
                                              Expanded(
                                                child: Text(
                                                    'Section : ${_answerList[ind]["section"]}',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white)),
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
                                    itemCount: _answerList[ind]["data"].length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      try {
                                        if (formfieldlist[index]
                                            .containsValue("textfield")) {
                                          return MyExamTextInput(
                                              ind,
                                              index,
                                              Map<String, dynamic>.from(
                                                  formfieldlist[index]),
                                              _locations);
                                        } else if (formfieldlist[index]
                                            .containsValue("checkbox")) {
                                          return MyCheckbox(
                                              ind,
                                              index,
                                              List<String>.from(
                                                  formfieldlist[index]
                                                      ["value"]),
                                              formfieldlist[index]["heading"],
                                              _locations);
                                        } else {
                                          return MyFormradio(
                                              ind,
                                              index,
                                              List<String>.from(
                                                  formfieldlist[index]
                                                      ["value"]),
                                              formfieldlist[index]["heading"],
                                              _locations);
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
                                  child: Text(
                                      ind == lengthd - 1 ? "Finish" : "Next"),
                                  onPressed: () async {
                                    setState(() {
                                      if (ind == lengthd - 1) {
                                        submitCopy();
                                      } else if (ind <= lengthd - 1) {
                                        ind++;
                                      }
                                      if (ind > lengthd - 1) {
                                        ind = lengthd - 1;
                                      }
                                    });
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
                ]))),
      );
    } catch (e) {
      return Scaffold();
    }
  }

  submitCopy() async {
    ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

    await Firestore.instance
        .collection("ExamJoin")
        .where("examId", isEqualTo: widget.examId)
        .where("email", isEqualTo: widget.candidateEmail)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        documentSnapshot.reference
            .updateData({"response": _answerList, "examName": widget.examName});
      });
      showAlertDialogs.showAlertDialog(
          context, "Your Response Successfuly Submitted");

      Navigator.pushReplacementNamed(context, '/');
    }).catchError((e) {
      showAlertDialogs.showAlertDialog(
          context, "Your Internet Connection is slow");
    });
  }
}

class MyExamTextInput extends StatefulWidget {
  final int ind;
  final int index;
  final List<String> _locations;
  final Map<String, dynamic> formfieldlist;

  MyExamTextInput(this.ind, this.index, this.formfieldlist, this._locations);
  @override
  _MyExamTextInputState createState() => _MyExamTextInputState();
}

class _MyExamTextInputState extends State<MyExamTextInput> {
  List<String> _locations = [];
  String _selectedLocation = "0";
  String ans = "";
  Map<String, dynamic> _formfieldlist = {};
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    setState(() {
      _formfieldlist.clear();
      ans = _answerList[widget.ind]["data"][widget.index]["answer"];
      _selectedLocation =
          _answerList[widget.ind]["data"][widget.index]["score"];
      _formfieldlist = widget.formfieldlist;
      _locations = widget._locations;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _selectedLocation =
          _answerList[widget.ind]["data"][widget.index]["score"].toString();
      ans = _answerList[widget.ind]["data"][widget.index]["answer"];
      _formfieldlist = widget.formfieldlist;
      _locations = widget._locations;
    });
    return Form(
        key: _formKey,
        child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                new Container(
                    margin: EdgeInsets.fromLTRB(15, 8, 15, 5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                  "Q${widget.index + 1} ${_formfieldlist['value']}",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 17.0)),
                            ),
                          ),
                          Container(
                              child: new DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                            alignedDropdown: true,
                            child: new DropdownButton(
                              hint: Text(_selectedLocation.toString()),
                              value: _selectedLocation.toString(),
                              style: const TextStyle(color: Colors.blueGrey),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              icon: const Icon(Icons.arrow_downward),
                              dropdownColor: Colors.blue,
                              onChanged: (newValue) {
                                setState(() {
                                  _answerList[widget.ind]["data"][widget.index]
                                      ["score"] = newValue.toString();
                                  _selectedLocation = _answerList[widget.ind]
                                      ["data"][widget.index]["score"];
                                });
                              },
                              items: _locations.map((location) {
                                return new DropdownMenuItem(
                                  child: new Text(location),
                                  value: location.toString(),
                                );
                              }).toList(),
                            ),
                          )))
                        ])),
                new Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      key: Key(ans.toString()),
                      initialValue: ans.toString(),
                      enabled: false,
                      onChanged: (text) {
                        _answerList[widget.ind]["data"][widget.index]
                            ["answer"] = text;
                      },
                    )),
              ]),
            ]));
  }
}

class MyCheckbox extends StatefulWidget {
  final int ind;
  final int index;
  final String title;
  final List<String> _locations;
  final List<String> checkboxlist;

  MyCheckbox(
      this.ind, this.index, this.checkboxlist, this.title, this._locations);
  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  List<bool> checkfalse = [];
  List<String> selectcheckbox = [];
  String _selectedLocation = "0";
  List<String> _locations = [];
  @override
  void initState() {
    setState(() {
      _selectedLocation =
          _answerList[widget.ind]["data"][widget.index]["score"];
      _locations = widget._locations;
      checkfalse =
          new List.filled(widget.checkboxlist.length, false, growable: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
          margin: EdgeInsets.all(15),
          child: Column(children: [
            Container(
                // margin: EdgeInsets.fromLTRB(15, 8, 15, 5),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Text("Q${widget.index + 1} ${widget.title}",
                          style: TextStyle(
                              color: Colors.blueAccent, fontSize: 17.0)),
                    ),
                  ),
                  Container(
                      child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      hint: Text(_answerList[widget.ind]["data"][widget.index]
                          ["score"]),
                      value: _selectedLocation,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      icon: const Icon(Icons.arrow_downward),
                      dropdownColor: Colors.amber,
                      onChanged: (newValue) {
                        setState(() {
                          _answerList[widget.ind]["data"][widget.index]
                              ["score"] = newValue.toString();
                          _selectedLocation = _answerList[widget.ind]["data"]
                              [widget.index]["score"];
                        });
                      },
                      items: _locations.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                  )))
                ])),
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
                      onChanged: (ch) {},
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
  final List<String> _locations;

  MyFormradio(
      this.ind, this.index, this.radioboxlist, this.title, this._locations);
  @override
  _MyFormradioState createState() => _MyFormradioState();
}

class _MyFormradioState extends State<MyFormradio> {
  String radioval = "";
  String _selectedLocation = "0";
  List<String> _locations = [];
  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedLocation =
          _answerList[widget.ind]["data"][widget.index]["score"];
      _locations = widget._locations;
      radioval = widget.radioboxlist[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        child: Column(children: [
          Container(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                child: Text("Q${widget.index + 1} ${widget.title}",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 17.0)),
              ),
            ),
            Container(
                child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                hint: Text(
                    _answerList[widget.ind]["data"][widget.index]["score"]),
                value: _selectedLocation,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                icon: const Icon(Icons.arrow_downward),
                dropdownColor: Colors.amber,
                onChanged: (newValue) {
                  setState(() {
                    _answerList[widget.ind]["data"][widget.index]["score"] =
                        newValue.toString();
                    _selectedLocation =
                        _answerList[widget.ind]["data"][widget.index]["score"];
                  });
                },
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
              ),
            )))
          ])),
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
                      groupValue: radioval,
                      onChanged: (val) {},
                    ),
                  );
                }),
          ),
        ]));
  }
}
