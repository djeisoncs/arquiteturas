
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoaging(context);
            }
          });

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CarouselSlider(
              options: CarouselOptions(enlargeCenterPage: true, aspectRatio: 1),
              items: [
                SurveyItem(),
                SurveyItem(),
                SurveyItem(),
              ],
            ),
          );
        },
      ),
    );
  }
}