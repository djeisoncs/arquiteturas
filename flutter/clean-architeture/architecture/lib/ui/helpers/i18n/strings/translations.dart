abstract class Translations {
  String get msgEmailInUse;
  String get msgInvalidCredentials;
  String get msgInvalidField;
  String get msgRequiredField;
  String get msgUnexpectedError;

  String get addAccount;
  String get confirmPassword;
  String get email;
  String get enter;
  String get login;
  String get name;
  String get password;
  String get reload;
  String get surveys;
  String get wait;

  Map<String, String> toJson() => {
    'msgInvalidCredentials': msgInvalidCredentials,
    'msgInvalidField': msgInvalidField,
    'msgRequiredField': msgRequiredField,
    'msgUnexpectedError': msgUnexpectedError,

    'addAccount': addAccount,
    'confirmPassword': confirmPassword,
    'email': email,
    'enter': enter,
    'login': login,
    'name': name,
    'password': password,
    'surveys': surveys,
    'wait': wait,
  };
}