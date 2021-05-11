import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;
  OptionTile(
      {@required this.option,
      @required this.correctAnswer,
      @required this.optionSelected,
      @required this.description});

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.description == widget.optionSelected
                        ? widget.optionSelected == widget.correctAnswer
                            ? Colors.green
                            : Colors.red
                        : Colors.blue,
          ),
          child:
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(
                    color: Colors.white,
                    width: 1.4),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                "${widget.option}",
                style: TextStyle(
                    color: 
                         Colors.white),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,

              ),
            )
          ],
        )));
  }
}
