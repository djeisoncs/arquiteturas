import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: R.strings.confirmPassword,
        icon:
        Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
      ),
      obscureText: true,
    );
  }
}
