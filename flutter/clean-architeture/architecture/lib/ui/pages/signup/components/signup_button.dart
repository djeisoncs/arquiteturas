import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';

import '../signup.dart';

class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignupPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton (
            onPressed: snapshot.data == true ? presenter.signUp : null,
            child: Text(R.string.addAccount.toUpperCase()),
          );
        });
  }
}
