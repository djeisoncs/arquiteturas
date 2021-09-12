import 'package:flutter/material.dart';

import '../../components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      child: SimpleDialog(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Aguarde...",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            }
          });

          return SingleChildScrollView(
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
                                  errorText: snapshot.data?.isNotEmpty == true
                                      ? snapshot.data
                                      : null,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: presenter.validateEmail,
                              );
                            }),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                            bottom: 32,
                          ),
                          child: StreamBuilder<String>(
                              stream: presenter.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    icon: Icon(Icons.lock,
                                        color: Theme.of(context)
                                            .primaryColorLight),
                                    errorText: snapshot.data?.isNotEmpty == true
                                        ? snapshot.data
                                        : null,
                                  ),
                                  obscureText: true,
                                  onChanged: presenter.validatePassword,
                                );
                              }),
                        ),
                        StreamBuilder<bool>(
                            stream: presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? presenter.auth
                                    : null,
                                child: Text("Entrar".toUpperCase()),
                              );
                            }),
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
          );
        },
      ),
    );
  }
}
