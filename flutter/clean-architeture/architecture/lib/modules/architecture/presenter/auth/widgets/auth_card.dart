

import 'package:architecture/modules/architecture/domain/entities/usuario.dart';
import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  bool _isLoaging = false;

  AuthMode _authMode = AuthMode.Login;

  Usuario authUser = Usuario();

  final _tLogin = TextEditingController();

  final _tSenha = TextEditingController();

  final _tConfirmarSenha = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _focusSenha = FocusNode();

  final _focusConfirmarSenha = FocusNode();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        height: _authMode == AuthMode.Login ? 290 : 371,
        width: deviceSize.width * 0.75,
        child: _form(),
      ),
    );
  }

  _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'E-mail'),
            controller: _tLogin,
            keyboardType: TextInputType.emailAddress,
            validator: _validateLogin,
            onSaved: (value) => authUser.email = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Senha'),
            controller: _tSenha,
            obscureText: true,
            validator: _validateSenha,
            onSaved: (value) => authUser.senha = value,
          ),
          if (_authMode == AuthMode.Signup)
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirmar Senha'),
              obscureText: true,
              validator: _validateConfirmacaoSenha,
            ),
          Spacer(),
          _isLoaging
              ? CircularProgressIndicator()
              : ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              primary: Theme.of(context).primaryColor,
              textStyle: TextStyle(
                color: Theme.of(context).primaryTextTheme.button.color,
              ),
              padding:
              EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            ),
            child: Text(
              _authMode == AuthMode.Login ? "Entrar" : "Registrar",
            ),
            onPressed: _onClickLogin,
          ),
          Container(
            height: 46,
            margin: EdgeInsets.only(top: 20),
            child: InkWell(
              onTap: _swichAuthMode,
              child: Text(
                _authMode == AuthMode.Login ? "Registrar" : "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onClickLogin() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoaging = true;
    });

    String email = _tLogin.text;
    String senha = _tSenha.text;

    if (_authMode == AuthMode.Login) {


      // ApiResponse response = await _provider.logar(email, senha);


      // _onLogar(await _bloc.login(login, senha));
    } else {
      // await _provider.signup(email, senha);
    }

    setState(() {
      _isLoaging = false;
    });
  }

  void _swichAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  String _validateLogin(String value) {
    if (value.isEmpty || !value.contains("@")) {
      return "Informe um e-mail válido";
    }
    return null;
  }

  String _validateSenha(String value) {
    if (value.isEmpty) {
      return "O digite a senha";
    }
    return null;
  }

  String _validateConfirmacaoSenha(String value) {
    if (_authMode == AuthMode.Signup && value != _tSenha.text) {
      return "As senhas são diferentes!!";
    }
    return null;
  }
}
