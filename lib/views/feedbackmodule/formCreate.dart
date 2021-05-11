import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/form.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:random_string/random_string.dart';

List<Map<String, dynamic>> formfieldlist = [];
String selectedfield = "textfield";

class MyForm extends StatefulWidget {
  final String selectfield;
  MyForm({this.selectfield});
  @override
  _MyFormState createState() => _MyFormState();
}

String formName = "";
String formDesc = "";

class _MyFormState extends State<MyForm> {
  List<bool> chList;
  FormDatabase databaseService = new FormDatabase();
  AuthServices authServices = new AuthServices();
  String useremail;
  String formId;
  bool _isloading = false;
  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        selectedfield = widget.selectfield;
        useremail = value;
      });
    });

    super.initState();
  }

  final TextEditingController eCtrl = new TextEditingController();

  void handleClick(String value) {
    switch (value) {
      case 'Textfield':
        setState(() {
          selectedfield = "textfield";
        });

        break;
      case 'Radiobox':
        setState(() {
          selectedfield = "textfield";
          selectedfield = "radiobox";
        });

        break;
      case 'Checkbox':
        setState(() {
          selectedfield = "checkbox";
        });

        break;
      case 'Reset':
        setState(() {
          formName = "";
          formDesc = "";
          formfieldlist.clear();
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Textfield', 'Radiobox', 'Checkbox', 'Reset'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: !_isloading
          ? Center(
              child: Container(
                alignment: Alignment.topLeft,
                  width: ResponsiveWidget.isLargeScreen(context) ||
                          ResponsiveWidget.isMediumScreen(context)
                      ? 800
                      : null,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: 
                      Container(
                        child: Column(
                          children: [
                          ResponsiveWidget.isLargeScreen(context) ||
                          ResponsiveWidget.isMediumScreen(context)
                      ?  GridView(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                ResponsiveWidget.isLargeScreen(
                                                            context) ||
                                                        ResponsiveWidget
                                                            .isMediumScreen(
                                                                context)
                                                    ? 2
                                                    : 1,
                                            crossAxisSpacing: 2.0,
                                            mainAxisSpacing: 2.0,
                                            childAspectRatio: 4.5),
                                    children: [
                                  GestureDetector(
                                    onTap: () {
                                      handleClick("Textfield");
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
                                        handleClick("Radiobox");
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(20),
                                          margin: EdgeInsets.all(10),
                                          width: 300,
                                          height: 50,
                                          child: Text("Radio Field",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          decoration: new BoxDecoration(
                                              color: Colors.orange[400],
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Colors.blueGrey.shade50,
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
                                        handleClick("Checkbox");
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(20),
                                          margin: EdgeInsets.all(10),
                                          width: 300,
                                          height: 50,
                                          child: Text("CheckBox Field",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          decoration: new BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Colors.blueGrey.shade50,
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
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          decoration: new BoxDecoration(
                                              color: Colors.cyan,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Colors.blueGrey.shade50,
                                                  offset: const Offset(
                                                    1.0,
                                                    1.0,
                                                  ),
                                                  blurRadius: 0.0,
                                                  spreadRadius: 1.0,
                                                ),
                                              ]))),
                                ])
                               : Container(),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Builder(builder: (context) {
                                  if (selectedfield == "textfield") {
                                    return mytextfield();
                                  } else if (selectedfield == "checkbox") {
                                    return Mych();
                                  } else {
                                    print("helll");
                                    return MyRadiobox();
                                  }
                                }),
                              ],
                            ),
                            Divider(height: 2.0),
                            Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                                child: Text(
                                  "FormName: $formName",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                                margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                child: Text(
                                  formDesc,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue),
                                )),
                            Divider(
                              height: 3.0,
                              color: Colors.grey,
                            ),
                            new ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: formfieldlist.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  try {
                                    if (formfieldlist[index]
                                        .containsValue("textfield")) {
                                      return new Padding(
                                        padding: EdgeInsets.all(15),
                                        child: TextField(
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: formfieldlist[index]
                                                  .values
                                                  .toList()
                                                  .first,
                                              hintText: '',
                                            ),
                                            onSubmitted: (text) {}),
                                      );
                                    } else if (formfieldlist[index]
                                        .containsValue("radiobox")) {
                                      var myradiolist = [];

                                      myradiolist =
                                          formfieldlist[index].values.toList();

                                      return Container(
                                          color: Colors.grey,
                                          margin: EdgeInsets.all(15),
                                          child: Column(children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                  formfieldlist[index]
                                                      .values
                                                      .toList()
                                                      .first,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0)),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      myradiolist[2].length,
                                                  itemBuilder:
                                                      (BuildContext con,
                                                          int ind) {
                                                    return ListTile(
                                                      title: Text(
                                                          myradiolist[2][ind]),
                                                      leading: Radio(
                                                        value: myradiolist[2]
                                                                [ind]
                                                            .toString(),
                                                        groupValue: " _site",
                                                        onChanged:
                                                            (String value) {
                                                          setState(() {});
                                                        },
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ]));
                                    } else {
                                      var mylis = [];

                                      mylis =
                                          formfieldlist[index].values.toList();

                                      return Container(
                                          margin: EdgeInsets.all(15),
                                          child: Column(children: [
                                            Container(
                                              color: Colors.grey,
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                  formfieldlist[index]
                                                      .values
                                                      .toList()
                                                      .first,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0)),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: mylis[2].length,
                                                  itemBuilder:
                                                      (BuildContext con,
                                                          int ind) {
                                                    return CheckboxListTile(
                                                      title:
                                                          Text(mylis[2][ind]),
                                                      value: false,
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          //  this.chList[ind]=true;
                                                        });
                                                      },
                                                    );
                                                  }),
                                            ),
                                          ]));
                                    }
                                  } catch (e) {
                                    return Container();
                                  }
                                })
                          ],
                        ),
                      )
                  )))
          : Container(child: Center(child: CircularProgressIndicator())),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            _isloading = true;
          });
          formId = randomAlphaNumeric(5);
          DateTime currentTime = DateTime.now();
          String cdt = currentTime.day.toString() +
              " : " +
              currentTime.month.toString() +
              " : " +
              currentTime.year.toString();
          Map<String, dynamic> myform = {
            "formId": formId,
            "formName": formName,
            "formDesc": formDesc,
            "formData": formfieldlist,
            "email": useremail,
            "date": cdt
          };
          ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
          await databaseService.addForm(myform, formId).then((value) {
            showAlertDialogs.showAlertDialog(
                context, "Form successfully created");
             setState(() {
            _isloading = true;
          });   
            Navigator.pushReplacementNamed(context, '/');
          }).catchError((e) {
            showAlertDialogs.showAlertDialog(
                context, "Your Internet connection is slow");
                setState(() {
            _isloading = true;
          });
          });
          formfieldlist.clear();
        },
        label: const Text('Submit'),
        icon: const Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      ),
    );
  }

  ShowDialogForName showDialogForName = new ShowDialogForName();

  Widget mytextfield() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter field value',
            hintText: '',
          ),
          autofocus: true,
          enableSuggestions: true,
          controller: eCtrl,
          onChanged: (val) async {
            if (formDesc == "" || formName == "") {
              await showDialogForName.showAlertDialog(context);
            }
          },
          onFieldSubmitted: (text) {
            if (text != "") {
              formfieldlist.add({"value": text, "type": "textfield"});
              eCtrl.clear();
              setState(() {
                selectedfield = "textfield";
              });
            }
          }),
    );
  }
}

//Form Name and Desc===========================

class ShowDialogForName {
  showAlertDialog(BuildContext context) async {
    AlertDialog alert = new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              new TextFormField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter FormName', hintText: ''),
                onChanged: (val) {
                  if (val != "") {
                    formName = val;
                  }
                },
              ),
              new TextFormField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter Form Description', hintText: ''),
                onChanged: (val) {
                  if (val != "") {
                    formDesc = val;
                  }
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
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
  ShowDialogForName showDialogForName = new ShowDialogForName();
  final TextEditingController eCtrl = new TextEditingController();
  String cfield = "cfield";
  checkquestion(String value) {
    checkmap.addAll({"heading": value, "type": "checkbox"});
  }

  @override
  Widget build(BuildContext context) {
    res() {
      setState(() {
        checklist = [];
        checkmap = {};
        checking = true;
      });
    }

    return Container(
      color: Colors.white,
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: TextFormField(
            enableSuggestions: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: ' Enter checkbox question',
              hintText: '',
            ),
            onChanged: (text) {
              checkquestion(text);
              if (formDesc == "" || formName == "") {
                showDialogForName.showAlertDialog(context);
              }
            },
            onFieldSubmitted: (text) {
              checkmap.addAll({"heading": text, "type": "checkbox"});
            },
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
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
                formfieldlist.add(somevar);

                setState(() {
                  selectedfield = "textfield";
                  checking = false;
                  res();
                });
              }
            },
            child: Text("Done"),
          ),
        ),
      ]),
    );
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
  ShowDialogForName showDialogForName = new ShowDialogForName();
  final TextEditingController eCtrl = new TextEditingController();
  String radiofield = "radiofield";

  radioquestions(String value) {
    radiomap.addAll({"heading": value, "type": "radiobox"});
  }

  @override
  Widget build(BuildContext context) {
    res() {
      setState(() {
        radiolist = [];
        radiomap = {};
        checking = true;
      });
    }

    return Container(
      color: Colors.white,
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: TextFormField(
            enableSuggestions: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: ' Enter Radio box Question',
              hintText: '',
            ),
            onChanged: (text) {
              radioquestions(text);

              if (formDesc == "" || formName == "") {
                showDialogForName.showAlertDialog(context);
              }
            },
          ),
        ),
        new ListView.builder(
            shrinkWrap: true,
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

                Map<String, dynamic> somevar = radiomap;
                formfieldlist.add(somevar);

                setState(() {
                  selectedfield = "textfield";
                  checking = false;
                  res();
                });
              }
            },
            child: Text("Done"),
          ),
        ),
      ]),
    );
  }
}
