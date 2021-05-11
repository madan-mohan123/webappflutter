import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return Center(
      child: RichText(
          text: TextSpan(style: TextStyle(fontSize: 22), children: <TextSpan>[
    TextSpan(
        text: 'Prep4',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
    TextSpan(
        text: 'Exam',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
  ])));
}

Widget blueButton({BuildContext context, String label, buttonWidth}) {
  return Container(
    alignment: Alignment.center,

    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(30),
    ),

    // fro takin complete width
    width: buttonWidth != null
        ? buttonWidth
        : MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
