
import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);



  Future<Map<String, String>> _headers() async {
    Map<String, String> headers = {
      "content-Type": "application/json",
      "accept": "application/json",
    };

    return headers;
  }

  @override
  Future<Map> request({
    @required String url,
    @required String method,
    Map body
  }) async {

    final headers = await _headers();

    String json = body != null ? jsonEncode(body) : null;

    var response = Response('', 500);

    try {
      if (method == 'post') {
        response = await client.post(Uri.parse(url), headers: headers, body: json);
      } else if (method == 'get') {
        response = await client.get(Uri.parse(url), headers: headers);
      }
    } catch(error) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    }

    throw HttpError.serverError;
  }
}