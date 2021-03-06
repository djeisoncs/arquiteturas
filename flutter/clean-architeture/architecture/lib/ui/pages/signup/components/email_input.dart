import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';

import '../signup.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignupPresenter>(context);
    return StreamBuilder<UIError>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextField(
            decoration: InputDecoration(
              labelText: R.string.email,
              icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.hasData ? snapshot.data.description : null,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}
