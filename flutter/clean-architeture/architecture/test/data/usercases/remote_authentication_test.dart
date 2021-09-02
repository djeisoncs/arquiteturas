
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  RemoteAuthentication({@required this.httpClient, @required this.url});
  Future<void> auth() async {
    await httpClient.request(url: url, method: "post");
  }
}

abstract class HttpClient {
  Future<void> request({
    @required url,
    @required method
  });
}

class HttpClientMock extends Mock implements HttpClient {}

main() {
  RemoteAuthentication sut;
  HttpClientMock httpClient;
  String url;

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test("Should call HttpClient with correct methodo", () async {

    await sut.auth();

    verify(httpClient.request(url: url, method: "post"));

  });
}