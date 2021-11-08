import 'package:architecture/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../survey_result_viewmodel.dart';
import 'components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  SurveyResult(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(viewModel.question);
        } else {
          return SurveyAnswer(viewModel.answers[index -1]);
        }
      },
      itemCount: viewModel.answers.length+1,
    );
  }
}
