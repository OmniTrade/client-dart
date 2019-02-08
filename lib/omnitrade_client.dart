library omnitrade_client;

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'src/services.dart';

/// Contains credentials to communicate with private API
class OmniCredentials {}

/// A client to communicate with OmniTrade.io API.
class OmniTradeClient extends OmniServices {
  OmniTradeClient({this.httpClient, this.credentials}) {
    credentials ??= OmniCredentials();
    httpClient ??= http.Client();
    client = ChopperClient(
      baseUrl: 'https://omnitrade.io/api/v2',
      jsonApi: true,
      client: httpClient
    );
  }

  OmniCredentials credentials;
  http.Client httpClient;
  ChopperClient client;
}
