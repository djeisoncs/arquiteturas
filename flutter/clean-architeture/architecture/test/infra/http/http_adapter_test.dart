
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({@required String url, @required String method, Map body}) async {
    final headers = await _headers();
    await client.post(Uri.parse(url), headers: headers);
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
      await sut.request(url: url, method: "post");

      verify(
          client.post(Uri.parse(url),
              headers: {
                "content-Type": "application/json",
                "accept": "application/json",
              }
          )
      );
    });
  });
}