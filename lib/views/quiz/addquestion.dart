import 'package:flutter/material.dart';
import 'package:prep4exam/services/quiz.dart';
import 'package:prep4exam/views/Breakpoints.dart';
import 'package:prep4exam/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();

  String question, option1, option2, option3, option4;
  bool _isLoading = false;
  Quizdatabase databaseService = new Quizdatabase();

  uploadQuestionData() async {
    
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };

      await databaseService
          .addQuestionData(questionMap, widget.quizId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        uploadQuestionData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.blueAccent,
            elevation: 0.0,
            brightness: Brightness.light,
       
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : 
          Center(
        child: Container(
          alignment: Alignment.topLeft,
      width: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 700
          : null,
          child:
          ListView(
            
            children:[
            Container(
              child:
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) => val.isEmpty ? "Question Required" : null,
                      decoration: InputDecoration(
                        hintText: "Write your Question",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val.isEmpty ? "Option 1 (correct) Required" : null,
                      decoration: InputDecoration(
                        hintText: "Option 1 (correct)",
                      ),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? "option 2 Required" : null,
                      decoration: InputDecoration(
                        hintText: "option 2",
                      ),
                      onChanged: (val) {
                        //
                        option2 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? "option 3 Required" : null,
                      decoration: InputDecoration(
                        hintText: "option 3",
                      ),
                      onChanged: (val) {
                        //
                        option3 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val.isEmpty ? "option 4 Required" : null,
                      decoration: InputDecoration(
                        hintText: "option 4",
                      ),
                      onChanged: (val) {
                        //
                        option4 = val;
                      },
                    ),
                     SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10),
                             boxShadow: [
                    BoxShadow(
                      color: Colors.cyan,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      spreadRadius: 1.0,
                    ),
                  ], 
                            ),
                          
                 child: Container(

                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.amber[600],
                      elevation: 10,
                      child: Center(
                           child:Container(
                             margin: EdgeInsets.all(5),
                             child: Text("Submit",style: TextStyle(color: Colors.white),),
                         
                           )
                          ),
                        )))),

                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            uploadQuestionData();
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10),
                             boxShadow: [
                    BoxShadow(
                      color: Colors.cyan,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      spreadRadius: 1.0,
                    ),
                  ], 
                            ),

                           child: Container(
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.green,
                      elevation: 10,
                      child: Center(
                            child:Container(
                             margin: EdgeInsets.all(5),
                             child: Text("Add Question",style: TextStyle(color: Colors.white),),
                         
                           )
                          ),
                        ))
                          
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),)],)
    )));
  }
}
