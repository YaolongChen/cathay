import 'package:http/http.dart' as http;

class AppHttpClient extends http.BaseClient {
  AppHttpClient();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return request.send();
  }
}
