import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/poll.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/views/poll/pollcreate.dart';
import 'package:prep4exam/views/poll/result.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class PollDashboard extends StatefulWidget {
  @override
  _PollDashboardState createState() => _PollDashboardState();
}

class _PollDashboardState extends State<PollDashboard> {

  String email = "";
  Stream polldata;
  List joinPollIdList;
  String joinpollId = "";
  PollDatabase databaseService = new PollDatabase();
  AuthServices authServices = new AuthServices();

  @override
  void initState() {
    //set current user email
    authServices.getcurrentuser().then((value) {
      setState(() {
        email = value;
      });
    });

    //return poll that is created
    databaseService.getPollData().then((val) {
      setState(() {
        polldata = val;
      });
    });

    //return list of join pollid
    databaseService.getPollJoinList().then((val) {
      setState(() {
        joinPollIdList = val;
      
      });
    });

    super.initState();
  }

  showAlertDialogForInvalidPollId(BuildContext context, String msg) {
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Sorry",
        style: TextStyle(fontSize: 20.0, color: Colors.red),
      ),
      content: Text(msg),
      actions: [
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

  _showDialogForEnterPollId() async {
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
                        labelText: 'Enter Poll Id', hintText: 'eg. xyz..'),
                    onChanged: (val) {
                      joinpollId = val;
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
                      var checkvalidpollId = await Firestore.instance
                          .collection("pollcreate")
                          .document(joinpollId)
                          .get();

                      if (checkvalidpollId.exists) {
                        bool alreadyexist = false;
                        await Firestore.instance
                            .collection("JoinPoll")
                            .where("email", isEqualTo: email)
                            .where("pollId", isEqualTo: joinpollId)
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
                          String cdt = currentTime.day.toString() + " : " +
                              currentTime.month.toString() + " : " +
                              currentTime.year.toString();
                          await Firestore.instance.collection("JoinPoll").add({
                            "email": email,
                            "pollId": joinpollId,
                            "voting": "---",
                            "date": cdt
                          });
                          ShowAlertDialogs showAlertDialogs =
                              new ShowAlertDialogs();
                          await showAlertDialogs.showAlertDialog(
                              context, "You Joined Poll Successfully");
                          Navigator.pop(context);
                        } else {
                          showAlertDialogForInvalidPollId(
                              context, "Already Join");
                        }
                      } else {
                        showAlertDialogForInvalidPollId(
                            context, "Invalid poll Id");
                      }
                    } catch (e) {
                      showAlertDialogForInvalidPollId(
                          context, "Slow Internat connection");
                    }
                  })
            ],
          );
        });
  }

  String _selectpollcretedorjoin = "MyPolls";

  void handleClick(String value) {
    switch (value) {
      case 'Assigned':
        setState(() {
          _selectpollcretedorjoin = "Assigned";
        });

        break;
      case 'MyPolls':
        setState(() {
          _selectpollcretedorjoin = "MyPolls";
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
            title:_selectpollcretedorjoin == "Assigned"? Text('Joined Polls'): Text('Created Polls'),
            backgroundColor: Colors.blueAccent,
            elevation: 0.0,
            brightness: Brightness.light,
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _showDialogForEnterPollId();
                    },
                    child: Icon(Icons.add_box_rounded),
                  )),
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Assigned', 'MyPolls'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ]),
        body:  Center(
        child: Container(
          alignment: Alignment.topCenter,
      width: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 700
          : null,
        child: _selectpollcretedorjoin == "MyPolls"
            ? createdpolllist()
            : assignedpolllist()
            )
            ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PollCreate()));
          },
        ),
      );
    } catch (e) {
      return Center(child: Container(child: CircularProgressIndicator()));
    }
  }

  Widget createdpolllist() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: polldata,
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
                          email) {
                        return VotingScore(
                            desc:
                                snapshot.data.documents[index].data["pollDesc"],
                            pollId:
                                snapshot.data.documents[index].data["pollId"],
                            date: snapshot.data.documents[index].data["date"]);
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
    );
  }

  Widget assignedpolllist() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: polldata,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      if (joinPollIdList.contains(
                          snapshot.data.documents[index].data["pollId"])) {
                        return PollTile(
                          desc: snapshot.data.documents[index].data["pollDesc"],
                          email: email,
                          pollId: snapshot.data.documents[index].data["pollId"],
                          date:snapshot.data.documents[index].data["date"]
                        );
                      } else {
                        return Container();
                      }
                    } catch (e) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
        },
      ),
    );
  }
}

class VotingScore extends StatefulWidget {
  final String desc;
  final String pollId;
  final String date;

  VotingScore({@required this.desc, @required this.pollId, this.date});
  @override
  _VotingScoreState createState() => _VotingScoreState();
}

class _VotingScoreState extends State<VotingScore> {
  int total = 0;
  int voting = 0;
  PollDatabase databaseService = new PollDatabase();
  @override
  void initState() {
    databaseService.getpollvoting(widget.pollId).then((val) {
      setState(() {
        total = val[0];
        voting = val[1];

        if (total == 0) {
          total = 1;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PollTileAdmin(
        desc: widget.desc,
        pollId: widget.pollId,
        atempt: voting,
        total: total,
        date: widget.date);
  }
}

class PollTileAdmin extends StatefulWidget {
  final String desc;
  final String pollId;

  final int atempt;
  final int total;
  final String date;

  PollTileAdmin(
      {@required this.desc,
      @required this.pollId,
      @required this.atempt,
      @required this.total,
      this.date});
  @override
  _PollTileAdminState createState() => _PollTileAdminState();
}

class _PollTileAdminState extends State<PollTileAdmin> {
  showAlertDialog(BuildContext context, String poll) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () async{
        Firestore.instance.collection("pollcreate").document(poll).delete();
         Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Warning ! ",
        style: TextStyle(fontSize: 20.0),
      ),
      content: Text("Would you like to Delete this poll " + poll),
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
        showAlertDialog(context, widget.pollId);
        break;
      case 'Copy':
        Clipboard.setData(new ClipboardData(text: "ID :  " + widget.pollId));
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultPoll(widget.pollId)));
          },
        
          child: Container(
              margin: EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(
                          0.0,
                          0.0,
                        ),
                        spreadRadius: 1.0,
                      ), //BoxShadow
                    ],
                  ),
                  child: Container(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.teal[400],
                          elevation: 10,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
                              child: Center(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

                                         ListTile(
                            title: Text(
                                        "ID: ${widget.pollId}",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                            trailing: PopupMenuButton<String>(
                              onSelected: handleClick,
                              itemBuilder: (BuildContext context) {
                                return {'Delete','Copy'}
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                                      
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.desc,
                                        style: TextStyle(
                                            // color: Colors.orangeAccent,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        height: 30,
                                        child: LiquidLinearProgressIndicator(
                                          value: widget.total <= 0
                                              ? 0
                                              : widget.atempt / widget.total,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.amber[700]),
                                          backgroundColor: Colors.white,
                                          borderColor: Colors.red[800],
                                          borderWidth: 2.0,
                                          borderRadius: 10.0,
                                          direction: Axis.horizontal,
                                          center: Text(
                                            ((widget.atempt / (widget.total)) *
                                                        100)
                                                    .toString() +
                                                "%",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.amber[800],
                                            ),
                                            child: Text(
                                                "Total : ${widget.total}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.blue[400],
                                            ),
                                            child: Text(
                                                "A/T : ${widget.atempt}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            widget.date,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ]),
                              )))),
                )
              ])));
    } catch (e) {
    
      return Container();
    }
  }
}

class PollTile extends StatefulWidget {
  final String desc;
  final String pollId;
  final String email;
  final String date;

  PollTile({
    @required this.desc,
    @required this.pollId,
    @required this.email,
    this.date
  });
  @override
  _PollTileState createState() => _PollTileState();
}

class _PollTileState extends State<PollTile> {
  String voting;

  _playpolldialog() async {
    await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Stack(
              children: <Widget>[
                Text(
                  "Type Your Response",
                  style: TextStyle(fontSize: 15.0),
                ),
                SizedBox(
                  height: 6.0,
                ),
                TextField(
                  autofocus: true,
                  decoration: new InputDecoration(labelText: '', hintText: ''),
                  onChanged: (val) {
                    voting = val;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    bool check = false;
                    await Firestore.instance
                        .collection("JoinPoll")
                        .where('email', isEqualTo: widget.email)
                        .where('pollId', isEqualTo: widget.pollId)
                        .getDocuments()
                        .then((mydata) {
                      mydata.documents.forEach((documentSnapshot) {
                        documentSnapshot.reference
                            .updateData({"voting": voting});
                        check = true;
                      });
                    }).catchError((e) {
                      ShowAlertDialogs showAlertDialogs =
                          new ShowAlertDialogs();

                     showAlertDialogs.showAlertDialog(
                          context, "Internet connection is Slow");
                    });
                    if (check) {
                      ShowAlertDialogs showAlertDialogs =
                          new ShowAlertDialogs();

                      await showAlertDialogs.showAlertDialog(
                          context, "Your Response Successfully Submitted");

                      Navigator.pop(context);
                    }
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _playpolldialog();
        },
        child: Container(
            margin: EdgeInsets.all(4.0),
            child: Stack(children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: new BoxDecoration(
                  color: Colors.indigo[600],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ), //BoxShadow
                    //                     //BoxShadow
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Id: ${widget.pollId}",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Date: ${widget.date}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Q. ${widget.desc}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
            ])));
  }
}
