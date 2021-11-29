import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';

import '../signup.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignupPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.nameErrorStream,
        builder: (context, snapshot) {
          return TextField(
            decoration: InputDecoration(
              labelText: R.string.name,
              icon: Icon(Icons.person, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data?.description,
            ),
            keyboardType: TextInputType.name,
            onChanged: presenter.validateName,
          );
        });
  }
}
