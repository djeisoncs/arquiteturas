import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';

import '../../components/components.dart';
import '../../mixins/mixins.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget with KeyboardManager, LoadingManager, UiErrorManager, NavigationManager {
  final SignupPresenter presenter;

  SignUpPage(this.presenter);

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
                  HeadLine1(text: R.string.addAccount),
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: ListenableProvider(
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            NameInput(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: EmailInput(),
                            ),
                            PasswordInput(),
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 32),
                              child: PasswordConfirmationInput(),
                            ),
                            SignupButton(),
                            TextButton.icon(
                              onPressed: presenter.goToLogin,
                              icon: const Icon(Icons.exit_to_app),
                              label: Text(R.string.login),
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

