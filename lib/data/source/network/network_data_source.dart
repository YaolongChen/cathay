import 'package:http/http.dart' as http;

class NetworkDataSource extends http.BaseClient {
  NetworkDataSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }
}
