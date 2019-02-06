library omnitrade_client;

import 'package:chopper/chopper.dart';
import 'src/services.dart';
import 'package:http/http.dart' as http;

class OmniCredentials {}

/// A OmniClient.
class OmniTradeClient extends OmniServices {
  OmniTradeClient({this.httpClient, this.credentials}) {
    credentials ??= OmniCredentials();
    httpClient ??= http.Client();
    client = ChopperClient(
      baseUrl: 'https://omnitrade.io',
      jsonApi: true,
      client: httpClient
    );
  }

  OmniCredentials credentials;
  http.Client httpClient;
  ChopperClient client;
}