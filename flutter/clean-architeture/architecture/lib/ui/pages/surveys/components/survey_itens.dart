
import 'package:architecture/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class SurveyItem extends StatelessWidget {
  final SurveyViewModel viewModel;

  SurveyItem(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                  blurRadius: 2,
                  color: Colors.black),
            ],
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewModel.dateTime,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              viewModel.question,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
