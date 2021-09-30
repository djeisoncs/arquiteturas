import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignupPresenter>(context);
    return StreamBuilder<UIError>(
      stream: presenter.passwordConfirmationErrorStream,
      builder: (context, snapshot) {
        return TextField(
          decoration: InputDecoration(
            labelText: R.strings.confirmPassword,
            icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
            errorText: snapshot.hasData ? snapshot.data.description : null,
          ),
          obscureText: true,
          onChanged: presenter.validatePasswordConfirmation,
        );
    });
  }
}
