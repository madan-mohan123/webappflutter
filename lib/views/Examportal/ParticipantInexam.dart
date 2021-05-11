import 'package:flutter/material.dart';
import 'package:prep4exam/services/exam.dart';
import 'package:prep4exam/views/Breakpoints.dart';


class ParticipantInExam extends StatefulWidget {
  final String examId;
  ParticipantInExam(this.examId);
  @override
  _ParticipantInExamState createState() => _ParticipantInExamState();
}

class _ParticipantInExamState extends State<ParticipantInExam> {
  Stream participantList;
  ExamDatabase databaseService = new ExamDatabase();

  @override
  void initState() {
    databaseService.examParticipants(widget.examId).then((value) {
      setState(() {
     
        participantList = value;
     
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text("Participants"),
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
       
          child: StreamBuilder(
              stream: participantList,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          try {
                           
                             
                              return participant(
                                  snapshot.data.documents[index].data["email"],
                                  index);
                            
                          } catch (e) {
                            return Container(
                              child: Center(
                                child: Text("None is Joined till Now"),
                              ),
                            );
                          }
                        });
              }),
        )),
      );
    } catch (e) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget participant(String email, int index) {
    return Container(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigo[400],
                    elevation: 10,
                    child:Container(
                     decoration: new BoxDecoration(
               color: Colors.blueGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),),
      child: ListTile(
        leading: Text(
          "#" + (index + 1).toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        title: Text(
          email.substring(0,1).toUpperCase() + email.substring(1,email.length),
          style: TextStyle(
              fontSize: 20,
              color: Colors.black45),
        ),
      ),
                    )
                )
    );
  }
}
