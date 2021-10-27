import 'package:http/http.dart';

import '../../../data/http/http.dart';
import '../../../infra/http/http.dart';

HttpClient makeAuthorizeHttpAdapterDecorator() {
  final client = Client();
  return HttpAdapter(client);
}