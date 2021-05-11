import 'package:flutter/material.dart';
import 'package:prep4exam/services/form.dart';
import 'package:prep4exam/views/Breakpoints.dart';

class FormResult extends StatefulWidget {
  final String id;

  FormResult(this.id);
  @override
  _FormResultState createState() => _FormResultState();
}

class _FormResultState extends State<FormResult> {
  FormDatabase databaseService = new FormDatabase();
  List<Map<String, dynamic>> formlist = [];
  List<String> headerlist = [];

  @override
  void initState() {
    databaseService.getJoinedForm(widget.id).then((value) {
      setState(() {
       
        formlist = List<Map<String, dynamic>>.from(value);
        
        headerlist.add("Email");
        
        List<String> random = [];
        random =formlist[0]["response"].keys.toList();
        for (int i = 0; i < random.length; i++) {
          headerlist.add(random[i].toString());
        }
        
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
          title: Text("Form Result"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body:Center(
            child: Container(
              alignment: Alignment.topCenter,
              width: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? null
                  : null,
        
       child: Container(
              
                  child:
         Container(
            child: ListView(shrinkWrap: true, children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dividerThickness: 5,
               columnSpacing: 30.0,
               showCheckboxColumn: true,
               
               
              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.cyan),
             dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
              columns: headerlist
                  .map((key) => DataColumn(label: Text(key,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.white),)))
                  .toList(),
              rows: formlist.map(
                ((element) {
                  String responseEmail = element["email"].toString();
                  List<dynamic> mylk =
                      List<dynamic>.from(element["response"].values.toList());
                  List<dynamic> k = [];
                  k.add(responseEmail);
                  for (int i = 0; i < mylk.length; i++) {
                    if (mylk[i] is String) {
                      k.add(mylk[i].toString());
                    
                    } else {
                      String s = mylk[i].join("-");
                      k.add(s);
                    }
                  }

                  return DataRow(
                    cells:
                        k.map((key) => DataCell(Container(
                         
                          child: Text(key.toString(),
                        )))).toList(),

                  );
                }),
              ).toList(),
            ),
          )
        ])),
      ))));
    } catch (e) {
  
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Form Result"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: Container(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
  }
}
