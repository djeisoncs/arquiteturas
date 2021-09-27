import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../signup.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: R.strings.password,
        icon:
        Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
      ),
      obscureText: true,
    );
  }
}
