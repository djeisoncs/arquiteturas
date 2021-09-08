import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:architecture/data/http/http.dart';

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
  Future<Map> request({String url, String method, Map body}) async {
    final headers = await _headers();
    String json = body != null ? jsonEncode(body) : null;
    final response = await client.post(Uri.parse(url), headers: headers, body: json);

    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    }

    return null;
  }
}

class ClientSpy extends Mock implements Client {}

main() {
  ClientSpy client;
  HttpAdapter sut;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpsUrl();
  });

  group("post", () {
    Map body;
    PostExpectation mockRequest() => when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode, {String body = ''}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      body = {'any_key': 'any_value'};

      mockResponse(200);
    });

    test("Should call post with correct values", () async {
      mockResponse(200, body: jsonEncode(body));

      await sut.request(url: url, method: "post", body: body);

      verify(
          client.post(
              Uri.parse(url),
              headers: {
                "content-Type": "application/json",
                "accept": "application/json",
              },
              body: jsonEncode(body)
          )
      );
    });

    test("Should call post without body", () async {
      await sut.request(url: url, method: "post");

      verify(client.post(any, headers: anyNamed("headers")));
    });

    test("Should return data if post returns 200", () async {
      mockResponse(200, body: jsonEncode(body));

      final response = await sut.request(url: url, method: "post");

      expect(response, body);
    });

    test("Should return null if post returns 200 with no data", () async {
      final response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Should return null if post returns 204", () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Should return null if post returns 204 with data", () async {
      mockResponse(204, body: jsonEncode(body));
      final response = await sut.request(url: url, method: "post");

      expect(response, null);
    });
  });
}