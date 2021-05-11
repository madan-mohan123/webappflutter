import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/form.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/feedbackmodule/formCreate.dart';
import 'package:prep4exam/views/feedbackmodule/formfill.dart';
import 'package:prep4exam/views/feedbackmodule/formresult.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormDash extends StatefulWidget {
  @override
  _FormDashState createState() => _FormDashState();
}

class _FormDashState extends State<FormDash> {
  FormDatabase databaseService = new FormDatabase();
  AuthServices authServices = new AuthServices();
  Stream allforms;
  String useremail = "";
  List<String> formids;
  String joinedformid;
  String _createjoinedform;
  @override
  void initState() {
    setState(() {
      _createjoinedform = "MyForms";
    });
    authServices.getcurrentuser().then((value) {
      setState(() {
        useremail = value;
      });
    });

    databaseService.getAllForms().then((value) {
      allforms = value;
    });

    databaseService.getFormIds().then((value) {
      formids = value;
    });

    super.initState();
  }

  void handleClick(String value) {
    switch (value) {
      case 'Assigned':
        setState(() {
          _createjoinedform = "Assigned";
        });

        break;
      case 'MyForms':
        setState(() {
          _createjoinedform = "MyForms";
        });

        break;
      case 'Add':
        setState(() {
          _showDialog();
        });

        break;
    }
  }

  _showDialog() async {
    await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Enter Form Id', hintText: 'eg. xxxxx'),
                    onChanged: (val) {
                      joinedformid = val;
                    },
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    try {
                      var checkid = await Firestore.instance
                          .collection("Forms")
                          .where('formId', isEqualTo: joinedformid)
                          .getDocuments();

                      if (checkid.documents.isNotEmpty) {
                        bool alreadyexist = false;
                        await Firestore.instance
                            .collection("FormJoin")
                            .where("email", isEqualTo: useremail)
                            .where("formId", isEqualTo: joinedformid)
                            .getDocuments()
                            .then((value) {
                          value.documents.forEach((documentSnapshot) {
                            if (documentSnapshot.exists) {
                              alreadyexist = true;
                            }
                          });
                        });
                        if (!alreadyexist) {
                          DateTime currentTime = DateTime.now();
                          String cdt = currentTime.day.toString() +
                              " : " +
                              currentTime.month.toString() +
                              " : " +
                              currentTime.year.toString();
                          Map<String, dynamic> data = {
                            "formId": joinedformid,
                            "email": useremail,
                            "response": {},
                            "date": cdt
                          };
                          await Firestore.instance
                              .collection("FormJoin")
                              .add(data);
                          Navigator.pop(context);
                        } else {
                          showDialogForWrongId(context, "Already Join");
                        }
                      } else {
                        showDialogForWrongId(context, "Invalid form Id");
                      }
                    } catch (e) {
                      showDialogForWrongId(context, "Slow connection");
                    }
                  })
            ],
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
          title: _createjoinedform == "Assigned"
              ? Text('Joined Forms')
              : Text('Created Forms'),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Assigned', 'MyForms', 'Add'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      body: (_createjoinedform == "MyForms")
          ? createdformlist()
          : assignedformlist(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyForm(selectfield: "textfield")));
        },
      ),
    );
  }

  Widget createdformlist() {
    return Center(
        child: Container(
      alignment: Alignment.topLeft,
      width: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 700
          : null,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: allforms,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      if (snapshot.data.documents[index].data["email"] ==
                          useremail) {
                        return CreatedForms(
                            snapshot.data.documents[index].data["formId"],
                            snapshot.data.documents[index].data["formName"],
                            snapshot.data.documents[index].data["formDesc"],
                            snapshot.data.documents[index].data["email"],
                            snapshot.data.documents[index].data["date"]);
                      } else {
                        return Text("");
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

  Widget assignedformlist() {
    return Center(
        child: Container(
      alignment: Alignment.topLeft,
      width: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 700
          : null,
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: allforms,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      if (formids.contains(
                          snapshot.data.documents[index].data["formId"])) {
                        return AssignedForm(
                            snapshot.data.documents[index].data["formId"],
                            snapshot.data.documents[index].data["formName"],
                            snapshot.data.documents[index].data["formDesc"],
                            snapshot.data.documents[index].data["email"],
                            snapshot.data.documents[index].data["date"]);
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

class CreatedForms extends StatefulWidget {
  final String id;
  final String formName;
  final String formDesc;
  final String formCreatedMail;
  final String date;
  CreatedForms(
      this.id, this.formName, this.formDesc, this.formCreatedMail, this.date);
  @override
  _CreatedFormsState createState() => _CreatedFormsState();
}

class _CreatedFormsState extends State<CreatedForms> {
  indicator(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  showAlertDialogForInvalidFormId(BuildContext context, String msg) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sorry", style: TextStyle(fontSize: 20.0, color: Colors.red)),
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

  bool isload = true;
  showAlertForDeleteForm(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        // indicator(context);
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () async {
        ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
        await Firestore.instance
            .collection("Forms")
            .where('formId', isEqualTo: widget.id)
            .getDocuments()
            .then((value) {
          value.documents.forEach((documentSnapshot) {
            documentSnapshot.reference.delete();
            showAlertDialogs.showAlertDialog(context, "Successfully Deleted");
            Navigator.of(context).pop();
          });
        }).catchError((e) {
          showAlertDialogs.showAlertDialog(context, "slow Internet connection");
        });
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning",
        style: TextStyle(color: Colors.red),
      ),
      content: Text("Would you like to Delete this From ${widget.id}"),
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

  void handleClick(String value) {
    switch (value) {
      case 'Delete':
        showAlertForDeleteForm(context);
        break;
      case 'Forms':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyFormFill(widget.id, widget.formName,
                    widget.formDesc, widget.formCreatedMail)));

        break;
        case 'Copy':
        Clipboard.setData(new ClipboardData(text: "ID :  " + widget.id));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormResult(widget.id)));
        },
        child: Container(
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
                  color: Colors.amber,
                  elevation: 10,
                  child: ListTile(
                    leading: Text(
                      widget.formName.toString().substring(0, 2).toUpperCase(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    title: Text(widget.formName),
                    subtitle: Text("ID: ${widget.id}  ${widget.date}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: handleClick,
                      itemBuilder: (BuildContext context) {
                        return {'Delete', 'Forms','Copy'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                   
                  ))),
        ),
      ),
    );
  }
}

class AssignedForm extends StatefulWidget {
  final String id;
  final String formName;
  final String formDesc;
  final String formCreatedMail;
  final String date;
  AssignedForm(
      this.id, this.formName, this.formDesc, this.formCreatedMail, this.date);
  @override
  _AssignedFormState createState() => _AssignedFormState();
}

class _AssignedFormState extends State<AssignedForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyFormFill(widget.id, widget.formName,
                    widget.formDesc, widget.formCreatedMail)));
      },
      child: Container(
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
                color: Colors.grey,
                elevation: 10,
                child: ListTile(
                  leading: Icon(Icons.font_download_rounded,
                      color: Colors.blue[600], size: 30),
                  title: Text(widget.formName,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  subtitle: Text("${widget.formDesc}  ${widget.date}",
                      style: TextStyle(color: Colors.white)),
                ))),
      ),
    ));
  }
}
