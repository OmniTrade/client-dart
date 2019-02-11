import 'dart:convert';
import 'package:test/test.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:omnitrade_client/src/helpers/injector.dart';
import 'package:http/http.dart';
import '../../helper.dart';

void main() {
  setUpAll(() {
    Injector.configure(kBaseUrl.contains('staging') ? Env.PROD : Env.TEST);
  });

  describe('fetchTimestamp', () {
    test('it returns server current time', () async {
      final expectedResult = 1549472661;

      final client = mockHttp(
        handleRequest: (_) async => Response(json.encode(expectedResult), 200),
        method: 'GET',
        url: '$kBaseUrl/timestamp'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.fetchTimestamp()).body;
      expect(subject, expectedResult);
    });
  });


  describe('generateTrezorChallenge', () {
    test('it returns a new Trezor challenge', () async {
      final expectedResult = {
        "visual": "2019-02-06T13:41:33.678Z",
        "hidden": "string"
      };

      final client = mockHttp(
        handleRequest: (_) async => Response(json.encode(expectedResult), 200),
        method: 'GET',
        url: '$kBaseUrl/trezor/new_challenge'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.generateTrezorChallenge()).body;
      expect(subject, expectedResult);
    });
  });
}