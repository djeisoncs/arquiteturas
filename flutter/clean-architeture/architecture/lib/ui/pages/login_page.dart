import 'package:flutter/material.dart';

import '../components/components.dart';

class LoginPage extends StatelessWidget {
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
                    TextField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          icon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColorLight,
                          ),

                      ),
                      keyboardType: TextInputType.emailAddress,
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
