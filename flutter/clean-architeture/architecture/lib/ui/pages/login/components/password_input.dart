import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../login.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextField(
            decoration: InputDecoration(
              labelText: R.string.password,
              icon:
                  Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data?.description,
            ),
            obscureText: true,
            onChanged: presenter.validatePassword,
          );
        });
  }
}
