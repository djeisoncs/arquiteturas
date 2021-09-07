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

    return response.body.isEmpty ? null : jsonDecode(response.body);
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
    Map body = {'any_key': 'any_value'};

    test("Should call post with correct values", () async {
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => Response(jsonEncode(body), 200));

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
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(jsonEncode(body), 200));

      await sut.request(url: url, method: "post");

      verify(client.post(any, headers: anyNamed("headers")));
    });

    test("Should return data if post returns 200", () async {
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => Response(jsonEncode(body), 200));

      final response = await sut.request(url: url, method: "post", body: body);

      expect(response, body);
    });

    test("Should return null if post returns 200 with no data", () async {
      when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => Response('', 200));

      final response = await sut.request(url: url, method: "post", body: body);

      expect(response, null);
    });
  });
}
