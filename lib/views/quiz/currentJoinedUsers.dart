import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/quiz.dart';
import 'package:prep4exam/views/Breakpoints.dart';

class CurrentlyJoinedStatus extends StatefulWidget {
  final String quizId;
  final List<String> blacklist;
  CurrentlyJoinedStatus(this.quizId, this.blacklist);
  @override
  _CurrentlyJoinedStatusState createState() => _CurrentlyJoinedStatusState();
}

class _CurrentlyJoinedStatusState extends State<CurrentlyJoinedStatus> {
  Quizdatabase databaseService = new Quizdatabase();
  Stream currentuser;
  List<String> blacklistStudent = [];
  List<Map<String, String>> listOfJoinedUsers;
  String participants = "Participants";
  bool _isloading = false;
  @override
  void initState() {
    databaseService.getCurrentlyJoinedUser(widget.quizId).then((value) {
      setState(() {
        currentuser = value;
        blacklistStudent = widget.blacklist;
      });
    });

    super.initState();
  }

  watingRoom(String blacklist) {
    switch (blacklist) {
      case 'WaitingRoom':
        setState(() {
          participants = "WaitingRoom";
        });

        break;
      case 'Participants':
        setState(() {
          participants = "Participants";
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
          title: participants == "Participants"
              ? Text('Current User')
              : Text('Waiting Room'),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          actions: [
            PopupMenuButton<String>(
              onSelected: watingRoom,
              itemBuilder: (BuildContext context) {
                return {'WaitingRoom', 'Participants'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      body: !_isloading
          ? Center(
              child: Container(
              width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? 800
                  : null,
              child: participants == "Participants"
                  ? StreamBuilder(
                      stream: currentuser,
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  try {
                                    return joinedUserTile(
                                        snapshot
                                            .data.documents[index].data["email"]
                                            .toString(),
                                        snapshot
                                            .data.documents[index].data["score"]
                                            .toString()
                                            .toUpperCase());
                                  } catch (e) {
                                    return Container();
                                  }
                                });
                      })
                  : blacklistStudent.isEmpty
                      ? Container(
                          child: Center(
                              child: Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
                                  padding: EdgeInsets.all(2.0),
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
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Text("Waiting Room Is Empty",
                                            style: TextStyle(fontSize: 20.0))),
                                  ))))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: blacklistStudent.length,
                          itemBuilder: (context, index) {
                            return blackListTile(blacklistStudent[index]);
                          }),
            ))
          : Container(child: Center(child: CircularProgressIndicator())),
    );
  }

  Widget blackListTile(String blacklistEmail) {
    return GestureDetector(
        onTap: () {
         
          removeFromBlackList(context, blacklistEmail);
        },
        child: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
            padding: EdgeInsets.all(2.0),
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
                ),
              ],
            ),
            child: Container(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigo[300],
                    elevation: 10,
                    child: ListTile(
                        leading: Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 30.0,
                          color: Colors.red,
                        ),
                        title: Text(
                          blacklistEmail,
                          style: TextStyle(fontSize: 20.0),
                        ))))));
  }

  removeFromBlackList(BuildContext context, String blacklistEmail) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () async {
         
        setState(() {
          _isloading = true;
          blacklistStudent.remove(blacklistEmail);
        });
        await Firestore.instance
            .collection("Quiz")
            .where('quizId', isEqualTo: widget.quizId)
            .getDocuments()
            .then((value) {
          value.documents.forEach((documentSnapshot) {
            documentSnapshot.reference
                .updateData({"blacklist": blacklistStudent});
          });
          showAlertDialogs.showAlertDialog(context, "Successfully Removed");
           setState(() {
            _isloading = false;
          });
        }).catchError((e) {
          showAlertDialogs.showAlertDialog(context, "Slow Internet connection");
           setState(() {
            _isloading = false;
          });
        });

        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content:
          Text("Would you like to Remove this Participant from Waiting Room"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget joinedUserTile(String userEmail, String score) {
    return GestureDetector(
        onDoubleTap: () {
          
          removeStudentDialog(context, userEmail);
        },
        child: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
            padding: EdgeInsets.all(2.0),
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
                ),
              ],
            ),
            child: Container(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigo[300],
                    elevation: 10,
                    child: ListTile(
                      leading: Icon(Icons.map_rounded,
                          color: Colors.orangeAccent, size: 30.0),
                      title: Text(
                        userEmail,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      subtitle: RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: 22),
                              children: <TextSpan>[
                            TextSpan(
                                text: 'Score ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                            TextSpan(
                                text: score,
                                style: TextStyle(color: Colors.grey)),
                          ])),
                    )))));
  }

  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

  removeStudentDialog(BuildContext context, String userEmail) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () async {
        setState(() {
          _isloading = true;
        });
        await Firestore.instance
            .collection("JoinQuiz")
            .where('quizId', isEqualTo: widget.quizId)
            .where('email', isEqualTo: userEmail)
            .getDocuments()
            .then((value) {
          value.documents.forEach((documentSnapshot) {
            documentSnapshot.reference.delete();
            setState(() {
              blacklistStudent.add(userEmail);
            });
          });
        }).catchError((e) {
          showAlertDialogs.showAlertDialog(context, "Slow Internet connection");
           setState(() {
          _isloading = false;
        });

        });
        await Firestore.instance
            .collection("Quiz")
            .document(widget.quizId)
            .updateData({"blacklist": blacklistStudent})
            .then((value) {})
            .catchError((e) {});

        await showAlertDialogs.showAlertDialog(
            context, "Quiz Successfully Deleted");
             setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to Remove this Participant"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
