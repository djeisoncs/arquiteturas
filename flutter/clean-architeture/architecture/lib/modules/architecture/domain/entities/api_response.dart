
class ApiResponse<T> {

  bool ok;
  String msg;
  T entity;
  List<T> entities;

  ApiResponse.ok({this.entity, this.msg}) {
    ok = true;
  }

  ApiResponse.addResponses(this.entities) {
    ok = true;
  }

  ApiResponse.addResponse(this.entity) {
    ok = true;
  }

  ApiResponse.error({this.entity, this.msg}) {
    ok = false;
  }
}