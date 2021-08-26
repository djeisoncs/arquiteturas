
import 'package:architecture/modules/architecture/domain/entities/entity.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert' as convert;

mixin Model<T extends Entity> implements Equatable {

  Map<String, dynamic> toMap();

  T clonar() => null;

  String toJson() => convert.json.encode(toMap());

  @override
  bool get stringify => true;
}