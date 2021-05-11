import 'package:flutter/material.dart';
import 'package:prep4exam/services/poll.dart';
import 'package:prep4exam/views/Breakpoints.dart';

import 'package:prep4exam/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:prep4exam/services/auth.dart';

class PollCreate extends StatefulWidget {
  @override
  _PollCreateState createState() => _PollCreateState();
}

class _PollCreateState extends State<PollCreate> {
  PollDatabase databaseService = new PollDatabase();
  AuthServices authServices = new AuthServices();
  final _formKey = GlobalKey<FormState>();
  String pollquestion;
  String pollId, pollDesc, _email;
  bool _isloading = false;
  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        _email = value;
        _isloading = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: _isloading
            ? Center(
                child: Container(
                width: ResponsiveWidget.isLargeScreen(context) ||
                        ResponsiveWidget.isMediumScreen(context)
                    ? 800
                    : null,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "Enter Poll Question" : null,
                        decoration: InputDecoration(
                          hintText: "Enter Poll Question!",
                        ),
                        onChanged: (val) {
                          pollquestion = val;
                        },
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () {
                          pollCreate();
                        },
                        child: blueButton(
                          context: context,
                          label: " Create poll",
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            : Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                ),
              ));
  }

  pollCreate() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isloading = false;
      });
      pollId = randomAlphaNumeric(5);
      DateTime currentTime = DateTime.now();
      String cdt = currentTime.day.toString() +
          " : " +
          currentTime.month.toString() +
          " : " +
          currentTime.year.toString();
      Map<String, dynamic> pollMap = {
        "pollId": pollId,
        "pollDesc": pollquestion,
        "email": _email,
        "votes": "0/0",
        "date": cdt
      };
      await databaseService.createPoll(pollMap, pollId).then((val) {
        
           setState(() {
        _isloading = true;
            });
          Navigator.pushReplacementNamed(context, '/');
      
      }).catchError((e) {
         setState(() {
        _isloading = true;
      });
        pollCreate();
      });
    }
  }
}
