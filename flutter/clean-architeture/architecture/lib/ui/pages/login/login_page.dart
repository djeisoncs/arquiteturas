import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LoginHeader(),
            HeadLine1(text: 'Login'),
            Padding(
              padding: EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: <Widget>[
                    StreamBuilder<String>(
                      stream: presenter.emailErrorStream,
                      builder: (context, snapshot) {
                        return TextField(
                          decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            errorText: snapshot.data,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: presenter.validateEmail,
                        );
                      }
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 32,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            labelText: 'Senha',
                            icon: Icon(Icons.lock,
                                color: Theme.of(context).primaryColorLight)),
                        obscureText: true,
                        onChanged: presenter.validatePassword,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Text("Entrar"),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.person),
                      label: Text('Criar Conta'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
