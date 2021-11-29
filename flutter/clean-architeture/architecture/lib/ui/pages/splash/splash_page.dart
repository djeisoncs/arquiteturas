
import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';

import 'splash_presenter.dart';

class SplashPage extends StatelessWidget with NavigationManager {
  final SplashPresenter presenter;

  SplashPage({required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccont();

    return Scaffold(
      appBar: AppBar(title: const Text('4Dev'),),
      body: Builder(
        builder: (context) {

          handleNavigation(presenter.navigateToStream, clear: true);

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

}