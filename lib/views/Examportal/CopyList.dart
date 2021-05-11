import 'package:flutter/material.dart';
import 'package:prep4exam/services/exam.dart';
import 'package:prep4exam/views/Examportal/checkCopy.dart';
import 'package:prep4exam/views/Breakpoints.dart';
class CopyList extends StatefulWidget {
  final String examId;
  CopyList(this.examId);
  @override
  _CopyListState createState() => _CopyListState();
}

class _CopyListState extends State<CopyList> {

   ExamDatabase databaseService = new ExamDatabase();

  List<Map<String, dynamic>> examCopyList = [];
  @override
  void initState() {
   
    databaseService.copyLis(widget.examId).then((value) {
      setState(() {
        examCopyList = List<Map<String, dynamic>>.from(value);

      });
    });
    super.initState();
  }

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
        body: 
        Center(
          child:
      
            Container(
              width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? 800
                  : null,
                 
            child: ListView.builder(
                itemCount: examCopyList.length,
                itemBuilder: (context, index) {
                  try {
                    List<Map<String, dynamic>> lst =
                        List<Map<String, dynamic>>.from(
                            examCopyList[index]["response"]);

                    return copyListTile(
                      examCopyList[index]['email'],
                       lst,
                     
                      examCopyList[index]['examId']
                       );
                  } catch (e) {
                 
                    return Container();
                  }
                })
                )
                ),
      );
    } catch (e) {
    
      return Container();
    }
  }

  Widget copyListTile(
      String candidateEmail, List<Map<String, dynamic>> examData,String examId) {
    return GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckCopy(
                      candidateEmail: candidateEmail,
                      examData: examData ,
                  
                      examId: examId,
                      )));
        },

         child:Container(
            padding:EdgeInsets.all(4.0) ,
              margin: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 6.0),
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
                    child:Container(
                     decoration: new BoxDecoration(
               color: Colors.blueGrey,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),),
         
          child: ListTile(
           leading: Text(
             candidateEmail.substring(0,3).toUpperCase(),
             style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
             ),
             
            
            title: Text(candidateEmail.substring(0,1).toUpperCase() + candidateEmail.substring(1,candidateEmail.length),),
            subtitle: Text(examId),
          ),
        )
                ))
                
                ));


        // child: Container(
        //   color: Colors.blue,
        //   child: ListTile(
        //     title: Text(candidateEmail),
        //     subtitle: Text(examId),
        //   ),
        // ));
  }
}
