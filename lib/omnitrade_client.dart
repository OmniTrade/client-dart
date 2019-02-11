library omnitrade_client;

import 'dart:collection';

import 'package:chopper/chopper.dart';
import 'package:omnitrade_client/src/helpers/utils.dart';
import 'package:omnitrade_client/src/models/order.dart';
import 'src/services.dart';
import 'package:http/http.dart' as http;

const String kBaseUrl = 'https://omnitrade.io/api/v2';

/// Contains credentials to communicate with private API
class OmniCredentials {
  OmniCredentials({this.accessKey, this.privateKey});

  final String accessKey;
  final String privateKey;

  bool get isPublicAccess => accessKey == null || privateKey == null;
}

/// A client to communicate with OmniTrade.io API.
class OmniTradeClient extends OmniServices {
  OmniTradeClient({this.httpClient, this.credentials}) {
    credentials ??= OmniCredentials();
    httpClient ??= http.Client();
    client = ChopperClient(
      baseUrl: kBaseUrl,
      jsonApi: true,
      client: httpClient
    );
  }

  OmniCredentials credentials;
  http.Client httpClient;
  ChopperClient client;
}