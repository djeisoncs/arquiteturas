import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';

import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget with KeyboardManager, LoadingManager, UiErrorManager, NavigationManager {
  final LoginPresenter presenter;

  LoginPage(this.presenter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);

          handleMainError(context, presenter.mainErrorStream);

          handleNavigation(presenter.navigateToStream, clear: true);

          return GestureDetector(
            onTap: () => hidekeyboard(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LoginHeader(),
                  HeadLine1(text: R.string.login),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: ListenableProvider(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            EmailInput(),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 32,
                              ),
                              child: PasswordInput(),
                            ),
                            LoginButton(),
                            TextButton.icon(
                              onPressed: presenter.goToSignUp,
                              icon: const Icon(Icons.person),
                              label: Text(R.string.addAccount),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

