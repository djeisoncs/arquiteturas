import 'package:flutter/material.dart';

import '../survey_answer_viewmodel.dart';
import 'active_icon.dart';
import 'disable_icon.dart';

class SurveyAnswer extends StatelessWidget {
  final SurveyAnswerViewModel viewModel;

  SurveyAnswer(this.viewModel);

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildItens() {
      List<Widget> children = [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(viewModel.answer, style: TextStyle(fontSize: 16)),
          ),
        ),
        Text(viewModel.percent,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
          ),
        ),
        viewModel.isCurrentAnswer ? ActiveIcon() : DisableIcon(),
      ];

      if (viewModel.image != null) {
        children.insert(0, Image.network(viewModel.image, width: 40));
      }
      return children;
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildItens(),
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
