import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:architecture/data/http/http.dart';
import 'package:architecture/infra/http/http.dart';

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

  group('Shared', () {
    test("Should throw ServerError if is invalid method is provided", () async {
      final future = sut.request(url: url, method: "invalid_method");

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group("post", () {
    Map body;
    PostExpectation mockRequest() => when(client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode, {String body = ''}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
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

    test("Should return BadRequestError if post returns 400 returns data", () async {
      mockResponse(400, body: jsonEncode(body));

      expect(sut.request(url: url, method: "post"), throwsA(HttpError.badRequest));
    });

    test("Should return BadRequestError if post returns 400", () async {
      mockResponse(400);

      expect(sut.request(url: url, method: "post"), throwsA(HttpError.badRequest));
    });

    test("Should return UnathorizedError if post returns 401", () async {
      mockResponse(401);

      expect(sut.request(url: url, method: "post"), throwsA(HttpError.unauthorized));
    });

    test("Should return Forbidden if post returns 403", () async {
      mockResponse(403);

      expect(sut.request(url: url, method: "post"), throwsA(HttpError.forbidden));
    });

    test("Should return NotFoundError if post returns 404", () async {
      mockResponse(404);

      expect(sut.request(url: url, method: "post"), throwsA(HttpError.notFound));
    });

    test("Should return ServerError if post returns 500", () async {
      mockResponse(500);

      expect(sut.request(url: url, method: "post"), throwsA(HttpError.serverError));
    });

    test("Should return ServerError if post throws", () async {
      mockError();

      expect(sut.request(url: url, method: "post"), throwsA(HttpError.serverError));
    });
  });

  group("get", () {
    Map body;
    PostExpectation mockRequest() => when(client.get(any, headers: anyNamed('headers')));

    void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test("Should call get with correct values", () async {
      mockResponse(200, body: jsonEncode(body));

      await sut.request(url: url, method: "get");

      verify(
          client.get(
              Uri.parse(url),
              headers: {
                "content-Type": "application/json",
                "accept": "application/json",
              }
          )
      );
    });

    test("Should return data if get returns 200", () async {
      mockResponse(200, body: jsonEncode(body));

      final response = await sut.request(url: url, method: "get");

      expect(response, body);
    });

    test("Should return null if get returns 200 with no data", () async {
      mockResponse(200, body: '');
      final response = await sut.request(url: url, method: "get");

      expect(response, null);
    });

    test("Should return null if get returns 204", () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: "get");

      expect(response, null);
    });

    test("Should return null if get returns 204 with data", () async {
      mockResponse(204, body: jsonEncode(body));

      final response = await sut.request(url: url, method: "get");

      expect(response, null);
    });

    test("Should return BadRequestError if get returns 400 returns data", () async {
      mockResponse(400, body: jsonEncode(body));

      expect(sut.request(url: url, method: "get"), throwsA(HttpError.badRequest));
    });

    test("Should return BadRequestError if get returns 400", () async {
      mockResponse(400);

      expect(sut.request(url: url, method: "get"), throwsA(HttpError.badRequest));
    });

    test("Should return UnathorizedError if get returns 401", () async {
      mockResponse(401);

      expect(sut.request(url: url, method: "get"), throwsA(HttpError.unauthorized));
    });

    test("Should return Forbidden if get returns 403", () async {
      mockResponse(403);

      expect(sut.request(url: url, method: "get"), throwsA(HttpError.forbidden));
    });
  });
}
