import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/services/exam.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:random_string/random_string.dart';

class ExamConduct extends StatefulWidget {
  final String examname;
  final DateTime examDate;
  final DateTime examStartTime;
  final String examDuration;

  ExamConduct(
      this.examname, this.examDate, this.examDuration, this.examStartTime);
  @override
  _ExamConductState createState() => _ExamConductState();
}

List examQuestionlist = [];
int checkingvariable = 0;
List<Map<String, dynamic>> datalist = [];
Map<String, dynamic> sections = {"section": ""};

class _ExamConductState extends State<ExamConduct> {
  String selectedfield = "textfield";
  int checkingvariable2 = 0;
  List<Map<String, dynamic>> formfieldlist = [];
  Storageinfo ob = new Storageinfo();

  ExamDatabase databaseService = new ExamDatabase();
  AuthServices authServices = new AuthServices();
  String _useremail = "";

  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        _useremail = value;
        sections.addAll({"section": "", "marks": ""});
        examQuestionlist.clear();
      });
    });

    super.initState();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Written Type':
        setState(() {
          selectedfield = "textfield";
        });

        break;
      case 'Objective Type':
        setState(() {
          selectedfield = "radiobox";
        });

        break;
      case 'MCQS Type':
        setState(() {
          selectedfield = "checkbox";
        });

        break;
      case 'Create Sections':
        setState(() {
          _showDialog();
        });

        break;
      case 'Reset':
        setState(() {
          examQuestionlist.clear();
          datalist.clear();
          sections.addAll({"section": ""});
          checkingvariable = 0;
          checkingvariable2 = 0;
        });

        break;
    }
  }

  final TextEditingController eCtrl = new TextEditingController();
  String sectionvalueonok = "";
  String sectionMarks = "";

  sectionvalues(String secval, String sectionMarks) {
    checkingvariable = 0;

    if (checkingvariable2 == 0) {
      checkingvariable2++;
    } else {
      sections.addAll({"data": datalist});
      Storageinfo df = new Storageinfo();
      df.setexamquestionlist(sections);
    }
    setState(() {
      datalist.clear();
      sections.addAll({"section": secval, "marks": sectionMarks});
    });
  }

  _showDialog() {
    showDialog<String>(
      context: context,
      builder: (context) {
        return Container(
          child: new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: <Widget>[
                  new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Section Name', hintText: 'eg. xxxxx'),
                    onChanged: (val) {
                      if (val != "") {
                        setState(() {
                          sectionvalueonok = val;
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
                        labelText: 'Each Question Marks', hintText: 'eg. 05'),
                    onChanged: (val) {
                      if (val != "") {
                        setState(() {
                          sectionMarks = val;
                        });
                      }
                    },
                  )
                ])),
            actions: <Widget>[
              new ElevatedButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    sectionvalues(sectionvalueonok, sectionMarks);
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Make Questions"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {
                  'Written Type',
                  'Objective Type',
                  'MCQS Type',
                  'Create Sections',
                  'Reset'
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Center(
            child: Container(
          alignment: Alignment.topLeft,
          width: ResponsiveWidget.isLargeScreen(context) ||
                  ResponsiveWidget.isMediumScreen(context)
              ? 800
              : null,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
              child: Container(
            child: Column(
              children: [
                Container(
                    child: ResponsiveWidget.isLargeScreen(context) ||
                            ResponsiveWidget.isMediumScreen(context)
                        ? GridView(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        ResponsiveWidget.isLargeScreen(
                                                    context) ||
                                                ResponsiveWidget.isMediumScreen(
                                                    context)
                                            ? 2
                                            : 1,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0,
                                    childAspectRatio: 4.5),
                            children: [
                                GestureDetector(
                                  onTap: () {
                                    handleClick("Written Type");
                                  },
                                  child: Container(
                                      width: 330,
                                      height: 50,
                                      margin: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "TextField",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      decoration: new BoxDecoration(
                                          color: Colors.blue[300],
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
                                            ),
                                          ])),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      handleClick("Objective Type");
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.all(10),
                                        width: 300,
                                        height: 50,
                                        child: Text("Radio Field",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        decoration: new BoxDecoration(
                                            color: Colors.orange[400],
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
                                              ),
                                            ]))),
                                GestureDetector(
                                    onTap: () {
                                      handleClick("MCQS Type");
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.all(10),
                                        width: 300,
                                        height: 50,
                                        child: Text("CheckBox Field",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        decoration: new BoxDecoration(
                                            color: Colors.redAccent,
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
                                              ),
                                            ]))),
                                GestureDetector(
                                    onTap: () {
                                      handleClick("Create Sections");
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.all(10),
                                        width: 300,
                                        height: 50,
                                        child: Text("More Sections",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        decoration: new BoxDecoration(
                                            color: Colors.cyan,
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
                                              ),
                                            ]))),
                                GestureDetector(
                                    onTap: () {
                                      handleClick("Reset");
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.all(10),
                                        width: 300,
                                        height: 50,
                                        child: Text("Reset",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        decoration: new BoxDecoration(
                                            color: Colors.cyan,
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
                                              ),
                                            ]))),
                              ])
                        : Container()),
                Builder(builder: (context) {
                  try {
                    if (selectedfield == "textfield") {
                      return mytextfield();
                    } else if (selectedfield == "checkbox") {
                      return Mych();
                    } else if (selectedfield == "radiobox") {
                      return MyRadiobox();
                    } else {
                      return Container(child: CircularProgressIndicator());
                    }
                  } catch (e) {
                    return Container(child: CircularProgressIndicator());
                  }
                }),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      child: new Text('Preview'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        sections.addAll({"data": datalist});
                        if (sections.values.toList()[0] == "") {
                          _showDialog();
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Preview(
                                _useremail,
                                widget.examname,
                                widget.examDate,
                                widget.examDuration,
                                widget.examStartTime);
                          }));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
        )));
  }

  Widget mytextfield() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
       children: [
      Padding(
        padding: EdgeInsets.all(15),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Questions',
            hintText: '',
          ),
          autofocus: true,
          enableSuggestions: true,
          controller: eCtrl,
          onChanged: (val) {
            if (sections["section"] == "" || sections["marks"] == "") {
              _showDialog();
            }
          },
          onFieldSubmitted: (text) {
            if (text != "") {
              if (sections.values.toList()[0] != "") {
                datalist.add({
                  "value": text,
                  "type": "textfield",
                  "answer": "",
                  "score": "0.0"
                });
                setState(() {
                  selectedfield = "textfield";
                  eCtrl.clear();
                });
              }
            }
          },
        ),
      ),
    ]);
  }
}

class Mych extends StatefulWidget {
  @override
  _MychState createState() => _MychState();
}

class _MychState extends State<Mych> {
  List<String> checklist = [];
  Map<String, dynamic> checkmap = {};
  bool checking = true;

  final TextEditingController eCtrl = new TextEditingController();
  String cfield = "cfield";
  @override
  Widget build(BuildContext context) {
    res() {
      setState(() {
        checklist = [];
        checkmap = {};
        checking = true;
      });
    }

    return ListView(
       physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
       children: [
      Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: ' Enter Checkbox Question ',
                hintText: '',
              ),
              onChanged: (text) {
                checkmap.addAll({
                  "heading": text,
                  "type": "checkbox",
                  "answer": [],
                  "score": "0.0"
                });
              },
            ),
          ),
          new ListView.builder(
              shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
              itemCount: checklist.length + 1,
              itemBuilder: (BuildContext ctxt, int index) {
                try {
                  if (cfield == "cfield") {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter options',
                          hintText: '',
                        ),
                        autofocus: true,
                        onFieldSubmitted: (text) {
                          checklist.add(text);
                          eCtrl.clear();
                          setState(() {
                            cfield = "cfield";
                          });
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } catch (e) {
                  return Container();
                }
              }),
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                if (checking) {
                  checkmap.addAll({"value": checklist});
                  Map<String, dynamic> somevar = checkmap;
                  datalist.add(somevar);
                  setState(() {
                    // selectedfield = "textfield";
                    checking = false;
                    res();
                  });
                }
              },
              child: Text("Done"),
            ),
          ),
        ]),
      )
    ]);
  }
}

class MyRadiobox extends StatefulWidget {
  @override
  _MyRadioboxState createState() => _MyRadioboxState();
}

class _MyRadioboxState extends State<MyRadiobox> {
  List<String> radiolist = [];
  Map<String, dynamic> radiomap = {};
  bool checking = true;

  final TextEditingController eCtrl = new TextEditingController();
  String radiofield = "radiofield";
  @override
  Widget build(BuildContext context) {
    res() {
      setState(() {
        radiolist = [];
        radiomap = {};
        checking = true;
      });
    }

    return ListView(
       physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true, children: [
      Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              enableSuggestions: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: ' Enter Objecive Question',
                hintText: '',
              ),
              onChanged: (text) {
                radiomap.addAll({
                  "heading": text,
                  "type": "radiobox",
                  "answer": "",
                  "score": "0.0"
                });
              },
            ),
          ),
          new ListView.builder(
              shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
              itemCount: radiolist.length + 1,
              itemBuilder: (BuildContext ctxt, int index) {
                try {
                  if (radiofield == "radiofield") {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter options',
                          hintText: '',
                        ),
                        autofocus: true,
                        onFieldSubmitted: (text) {
                          radiolist.add(text);
                          eCtrl.clear();
                          setState(() {
                            radiofield = "radiofield";
                          });
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } catch (e) {
                  return Container();
                }
              }),
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                if (checking) {
                  radiomap.addAll({"value": radiolist});

                  datalist.add(radiomap);
                  setState(() {
                    checking = false;
                    res();
                  });
                }
              },
              child: Text("Done"),
            ),
          ),
        ]),
      )
    ]);
  }
}

//Class Preview for showing Questions before Submit ============================================================
class Preview extends StatefulWidget {
  final String examname;
  final String email;
  final DateTime examDate;
  final DateTime examStartTime;
  final String examDuration;
  Preview(this.email, this.examname, this.examDate, this.examDuration,
      this.examStartTime);
  @override
  _PreviewState createState() => _PreviewState();
}

List<Map<String, dynamic>> formfieldlist = [];

class _PreviewState extends State<Preview> {
  bool submitOneTime = true;
  ExamDatabase databaseService = new ExamDatabase();
  Storageinfo storageinfoobject = new Storageinfo();
  bool _isloading = false;
  List<Map<String, dynamic>> urli = [];

  @override
  void initState() {
    if (checkingvariable == 0) {
      Storageinfo df = new Storageinfo();
      sections.addAll({"data": datalist});

      df.setexamquestionlist(sections);

      checkingvariable++;
    } else {
      for (int i = 0; i < examQuestionlist.length; i++) {
        if (examQuestionlist[i]
            .values
            .toList()
            .contains(sections.values.toList()[0])) {
          examQuestionlist[i]["data"] = sections.values.toList()[2];

          break;
        }
      }
    }

    setState(() {
      urli = List<Map<String, dynamic>>.from(
          storageinfoobject.getexamquestionlist());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          title: Text("${widget.examname}"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: !_isloading
            ? Center(
                child: Container(
                    alignment: Alignment.topLeft,
                    width: ResponsiveWidget.isLargeScreen(context) ||
                            ResponsiveWidget.isMediumScreen(context)
                        ? 800
                        : null,
                    child: ListView(shrinkWrap: true, children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "Exam Name: ${widget.examname}",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w500),
                          )),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "ExamDate :${widget.examDate.day.toString()}-${widget.examDate.month.toString()}-${widget.examDate.year.toString()}",
                            style: TextStyle(fontSize: 20.0),
                          )),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "Duration: ${widget.examDuration} Min",
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.blueAccent),
                          )),
                      Divider(
                        height: 3.0,
                        color: Colors.grey,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: urli.length,
                          itemBuilder: (BuildContext context, int ind) {
                            formfieldlist = urli[ind].values.toList()[1];
                            return ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 15, 15, 10),
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      color: Colors.deepOrange,
                                      child: Text(
                                          "Section : ${urli[ind].values.toList()[0]}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white))),
                                  Container(
                                      child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: urli[ind]
                                              .values
                                              .toList()[1]
                                              .length,
                                          itemBuilder:
                                              (BuildContext ctxt, int index) {
                                            try {
                                              if (formfieldlist[index]
                                                  .containsValue("textfield")) {
                                                return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      new Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                15, 8, 15, 5),
                                                        child: Text(
                                                            "Q${index + 1} ${formfieldlist[index].values.toList().first}",
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                      ),
                                                      new Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                15, 5, 15, 5),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 10),
                                                        child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Type Your Answer Here",
                                                              hintText: '',
                                                            ),
                                                            onSubmitted:
                                                                (text) {}),
                                                      ),
                                                    ]);
                                              } else if (formfieldlist[index]
                                                  .containsValue("checkbox")) {
                                                var mylis = [];
                                                mylis = formfieldlist[index]
                                                    .values
                                                    .toList();

                                                return ListView(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: [
                                                      Container(
                                                          //  color: Colors.blue,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          10),
                                                                  child: Text(
                                                                      "Q${index + 1} : ${formfieldlist[index]['heading']}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                ),
                                                                Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount: mylis[4]
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext con, int ind) {
                                                                            return CheckboxListTile(
                                                                              title: Text(mylis[4][ind]),
                                                                              value: false,
                                                                              onChanged: (value) {
                                                                                setState(() {});
                                                                              },
                                                                            );
                                                                          }),
                                                                ),
                                                              ]))
                                                    ]);
                                              } else {
                                                var myradiolist = [];

                                                myradiolist =
                                                    formfieldlist[index]
                                                        .values
                                                        .toList();

                                                return ListView(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: [
                                                      Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  15),
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          10),
                                                                  child: Text(
                                                                      "Q${index + 1} : ${formfieldlist[index]['heading']}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                ),
                                                                Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: ListView
                                                                      .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemCount: myradiolist[4]
                                                                              .length,
                                                                          itemBuilder:
                                                                              (BuildContext con, int ind) {
                                                                            return ListTile(
                                                                              title: Text(myradiolist[4][ind]),
                                                                              leading: Radio(
                                                                                value: myradiolist[4][ind].toString(),
                                                                                groupValue: " _site",
                                                                                onChanged: (value) {
                                                                                  setState(() {});
                                                                                },
                                                                              ),
                                                                            );
                                                                          }),
                                                                ),
                                                              ]))
                                                    ]);
                                              }
                                            } catch (e) {
                                              return Container();
                                            }
                                          }))
                                ]);
                          })
                    ])))
            : Container(child: Center(child: CircularProgressIndicator())),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            String examId = randomAlphaNumeric(6);
            Map<String, dynamic> examData = {
              "examname": widget.examname,
              "examDate": widget.examDate,
              "examDuration": widget.examDuration,
              "examstartTime": widget.examStartTime,
              "examdata": examQuestionlist,
              "examid": examId,
              "email": widget.email,
            };

            ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

            if (submitOneTime) {
              setState(() {
                _isloading = true;
              });
              await databaseService.addExam(examData).then((value) {
                showAlertDialogs.showAlertDialog(
                    context, "Exam Created Successfuly");
                setState(() {
                  _isloading = false;
                });
                examQuestionlist.clear();
                sections.clear();

                Navigator.pushReplacementNamed(context, '/');
              }).catchError((e) {
                showAlertDialogs.showAlertDialog(
                    context, "Your Internet Connection is Slow");
                setState(() {
                  _isloading = false;
                });
              });

              setState(() {
                submitOneTime = false;
              });
            } else {
              showAlertDialogs.showAlertDialog(
                  context, "You Have Already submitted the Exam");
            }
          },
          label: const Text('submit'),
          icon: const Icon(Icons.send),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}

class Storageinfo {
  int va = 0;

  Map<String, dynamic> mylast = {};
  List l = [];
  List getexamquestionlist() {
    return examQuestionlist;
  }

  setexamquestionlist(Map<String, dynamic> data) {
    for (int i = 0; i < examQuestionlist.length; i++) {
      if (examQuestionlist[i].values.toList()[0] ==
          sections.values.toList()[0]) {
        l = List<Map<String, dynamic>>.from(sections.values.toList()[2]);
        examQuestionlist[i]["data"] = l;

        va = 1;
        break;
      } else {}
    }
    if (va == 0) {
      mylast.addAll({
        "section": sections.values.toList()[0],
        "data": List<Map<String, dynamic>>.from(sections.values.toList()[2]),
        "marks": sections.values.toList()[1],
      });

      examQuestionlist.add(mylast);
    }
  }
}
