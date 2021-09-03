

class AccountEntity {

  String token;

  AccountEntity(this.token);

  factory AccountEntity.fromJson(Map json) => AccountEntity(json['accessToken']);
}