import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request(
      {@required String url, @required String method, body}) async {
    final headers = await _headers();
    await client.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
  }

  Future<Map<String, String>> _headers() async {
    Map<String, String> headers = {
      "content-Type": "application/json",
      "accept": "application/json",
    };

    return headers;
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
    test("Should call post with correct values", () async {
      Map body = {'any_key': 'any_value'};

      await sut.request(url: url, method: "post", body: body);

      verify(
          client.post(Uri.parse(url),
              headers: {
                "content-Type": "application/json",
                "accept": "application/json",
              },
              body: jsonEncode(body)
          )
      );
    });
  });
}
