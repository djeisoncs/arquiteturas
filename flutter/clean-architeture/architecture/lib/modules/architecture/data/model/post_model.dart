
import 'package:architecture/modules/architecture/domain/entities/post.dart';

class PostModel extends Post {
  int userId;
  int id;
  String title;
  String body;

  PostModel({this.userId, this.id, this.title, this.body});

  PostModel.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    id = map['id'];
    title = map['title'];
    body = map['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}