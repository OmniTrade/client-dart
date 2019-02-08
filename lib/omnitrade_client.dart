library omnitrade_client;

import 'package:chopper/chopper.dart';
import 'src/services.dart';
import 'package:http/http.dart' as http;

/// Contains credentials to communicate with private API
class OmniCredentials {
  final String accessKey;
  final String privateKey;

  OmniCredentials({this.accessKey, this.privateKey});
}

/// A client to communicate with OmniTrade.io API.
class OmniTradeClient extends OmniServices {
  OmniTradeClient({this.httpClient, this.credentials}) {
    credentials ??= OmniCredentials();
    httpClient ??= http.Client();
    client = ChopperClient(
      baseUrl: 'https://staging.omnitrade.io/api/v2',
      jsonApi: true,
      client: httpClient
    );
  }

  OmniCredentials credentials;
  http.Client httpClient;
  ChopperClient client;
}
