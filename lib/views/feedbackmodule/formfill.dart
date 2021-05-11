import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/services/form.dart';
import 'package:prep4exam/views/Breakpoints.dart';

import 'package:prep4exam/widgets/widgets.dart';

Map<String, dynamic> _mymap = {};

class MyFormFill extends StatefulWidget {
  final String formId;
  final String formName;
  final String formDesc;
  final String formCreatedMail;
  MyFormFill(this.formId, this.formName, this.formDesc, this.formCreatedMail);

  @override
  _MyFormFillState createState() => _MyFormFillState();
}

class _MyFormFillState extends State<MyFormFill> {
  var checkboxlist = [];
  List formfieldlist = [];
  FormDatabase databaseService = new FormDatabase();
  AuthServices authServices = new AuthServices();
  String useremail;
  bool _isloading = false;

  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      useremail = value;
    });

    databaseService.getForm(widget.formId).then((value) {
      setState(() {
        formfieldlist = value;

        _mymap.clear();
      });
    });

    super.initState();
  }

  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          actions: <Widget>[],
        ),
        body: !_isloading ?
        Center(
            child: Container(
                width: ResponsiveWidget.isLargeScreen(context) ||
                        ResponsiveWidget.isMediumScreen(context)
                    ? 800
                    : null,
                child: new ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                            decoration: new BoxDecoration(
                              color: Colors.blueGrey[700],
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
                            margin: EdgeInsets.fromLTRB(6, 10, 6, 5),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              widget.formName,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                            child: Text(
                              widget.formDesc,
                              style: TextStyle(fontSize: 20.0),
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Text(
                              "*Email: $useremail",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.blueAccent),
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
                                    .values
                                    .toList()
                                    .contains("textfield")) {
                                  return new Padding(
                                    padding: EdgeInsets.all(15),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: formfieldlist[index]
                                            ["value"],
                                        hintText: 'Give Your Response',
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (text) {
                                        _mymap.addAll({
                                          formfieldlist[index]["value"]
                                              .toString(): text
                                        });
                                      },
                                    ),
                                  );
                                } else if (formfieldlist[index]
                                    .values
                                    .toList()
                                    .contains("radiobox")) {
                                  return MyFormradio(
                                      index,
                                      List<String>.from(
                                          formfieldlist[index]["value"]),
                                      formfieldlist[index]["heading"]);
                                } else {
                                  return MyFormCheckbox(
                                      index,
                                      List<String>.from(
                                          formfieldlist[index]["value"]),
                                      formfieldlist[index]["heading"]);
                                }
                              } catch (e) {
                                return Container();
                              }
                            })
                      ],
                    )
                  ],
                ))) : Container(child:Center(child:CircularProgressIndicator())),
        floatingActionButton: Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
            _isloading = true;
          });
                ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
                await databaseService
                    .saveFormResponse(_mymap, useremail, widget.formId,
                        widget.formName, widget.formDesc)
                    .then((value) {
                  showAlertDialogs.showAlertDialog(
                      context, "Your Response Successfuly Submitted");
                      setState(() {
            _isloading = false;
          });

                  Navigator.pushReplacementNamed(context, '/');
                }).catchError((e) {
                  showAlertDialogs.showAlertDialog(
                      context, "Your Internet connection is Slow ! ");
                            setState(() {
            _isloading = false;
          });
                });
              },
              label: const Text('Done'),
              icon: const Icon(Icons.send),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } catch (e) {
      return Scaffold(
          body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    }
  }
}

class MyFormCheckbox extends StatefulWidget {
  final int ind;
  final String title;
  final List<String> checkboxlist;

  MyFormCheckbox(this.ind, this.checkboxlist, this.title);
  @override
  _MyFormCheckboxState createState() => _MyFormCheckboxState();
}

class _MyFormCheckboxState extends State<MyFormCheckbox> {
  List<bool> checkfalse = [];
  List<String> selectcheckbox = [];
  @override
  void initState() {
    setState(() {
      checkfalse =
          new List.filled(widget.checkboxlist.length, false, growable: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
          color: Colors.blue,
          margin: EdgeInsets.all(15),
          child: Column(children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(5),
              child: Text(widget.title, style: TextStyle(color: Colors.white)),
            ),
            Container(
              // height: 150.0,
              color: Colors.white,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.checkboxlist.length,
                  itemBuilder: (BuildContext con, int indf) {
                    return CheckboxListTile(
                      title: Text(widget.checkboxlist[indf]),
                      value: checkfalse[indf],
                      onChanged: (ch) {
                        setState(() {
                          if (checkfalse[indf]) {
                            this.checkfalse[indf] = false;
                            selectcheckbox.remove(widget.checkboxlist[indf]);
                            _mymap.addAll({widget.title: selectcheckbox});
                          } else {
                            this.checkfalse[indf] = true;

                            selectcheckbox.add(widget.checkboxlist[indf]);
                            _mymap.addAll({widget.title: selectcheckbox});
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
  final int index;
  final String title;
  final List<String> radioboxlist;

  MyFormradio(this.index, this.radioboxlist, this.title);
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
        color: Colors.orangeAccent,
        margin: EdgeInsets.all(15),
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(5),
            child: Text(widget.title, style: TextStyle(color: Colors.white)),
          ),
          Container(
            // height: 150.0,
//
            color: Colors.white,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.radioboxlist.length,
                itemBuilder: (BuildContext con, int ind) {
                  return ListTile(
                    title: Text(widget.radioboxlist[ind]),
                    leading: Radio(
                      value: widget.radioboxlist[ind].toString(),
                      groupValue: radioval,
                      onChanged: (val) {
                        setState(() {
                          this.radioval = val.toString();
                          _mymap.addAll({widget.title: val});
                        });
                      },
                    ),
                  );
                }),
          ),
        ]));
  }
}
