import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {
  When mockPostCall() => when(() =>
      this.post(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      mockPostCall().thenAnswer((_) async => Response(body, statusCode));
  void mockPostError() => mockPostCall().thenThrow(Exception());

  When mockPutCall() => when(() => this.put(any(), body: any(named: 'body'), headers: any(named: 'headers')));
  void mockPut(int statusCode, {String body = '{"any_key":"any_value"}'}) => this.mockPutCall().thenAnswer((_) async => Response(body, statusCode));
  void mockPutError() => when(() => mockPutCall().thenThrow(Exception()));

  When mockGetCall() => when(() => this.get(any(), headers: any(named: 'headers')));
  void mockGet(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      mockGetCall().thenAnswer((_) async => Response(body, statusCode));
  void mockGetError() => mockGetCall().thenThrow(Exception());
}