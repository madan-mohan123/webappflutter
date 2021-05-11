import 'package:flutter/material.dart';
import 'package:prep4exam/services/quiz.dart';
import 'package:prep4exam/views/Breakpoints.dart';

class ShowResult extends StatefulWidget {
  final String quizId;
  ShowResult(this.quizId);
  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  Quizdatabase databaseService = new Quizdatabase();
  List<Map<String, String>> listOfColumns;
  bool _isloading = false;
  @override
  void initState() {
    databaseService.getScore(widget.quizId).then((value) {
      setState(() {
        listOfColumns = List<Map<String, String>>.from(value);
        _isloading = true;
        print(listOfColumns);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Result'),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: _isloading
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical, child: Center(child: Container(
                  alignment:Alignment.topCenter,
                  width: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 700
          : null,
                  child: resultTile(),),))
            : Container(
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                )),
              ),
      );
    } catch (e) {
      return Scaffold(
          body: Container(
              child: Center(
                  child: CircularProgressIndicator(
        backgroundColor: Colors.red,
      ))));
    }
  }

  Widget resultTile() {
    try {
      return Column(
        children: [
          DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.amber[300]),
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
            columns: [
              DataColumn(
                  label: Text('UserName',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Scores',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ],
            rows: listOfColumns.isEmpty
                ? DataRow(cells: <DataCell>[
                    DataCell(Text("")),
                    DataCell(Text("")),
                  ])
                : listOfColumns
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(element["Email"],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ))),
                              DataCell(Text(element["Score"],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ))),
                            ],
                          )),
                    )
                    .toList(),
          ),
        ],
      );
    } catch (e) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
