import 'package:faker/faker.dart';

class FackeAccountFactory {

  static Map makeApiJson() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

}