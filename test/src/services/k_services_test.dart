import 'dart:convert';
import 'package:test/test.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:chopper/chopper.dart' as Chopper show Response;
import 'package:omnitrade_client/src/helpers/injector.dart';
import 'package:http/http.dart';
import '../../helper.dart';

void main() {
  setUpAll(() {
    Injector.configure(Env.TEST);
  });

  describe('fetchK', () {
    when('market is invalid', () {
      test('it returns http status 404', () {
        final expectedResult = {
          "error": {
            "code": 1002,
            "message": "Couldn't find Market with 'id'=anything"
          }
        };

        final client = mockHttp(
            handleRequest: (_) async => Response(json.encode(expectedResult), 404),
            method: 'GET',
            url: '$kBaseUrl/k?market=anything&limit=30&period=1&timestamp=null'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        expect(() => omniClient.fetchK('anything'), throwsA(TypeMatcher<Chopper.Response>()));
      });
    });

    when('market valid', () {
      test('it returns list with OHLC(k line) of specific market', () async {
        final expectedResult = [
          [1549469940, 12700, 12700, 12700, 12700, 0],
        ];

        final client = mockHttp(
            handleRequest: (_) async => Response(json.encode(expectedResult), 200),
            method: 'GET',
            url: '$kBaseUrl/k?market=btcbrl&limit=30&period=1&timestamp'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchK('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });

  describe('fetchKWithPendingTrades', () {
    when('market is invalid', () {
      test('it returns http status 404', () {
        final expectedResult = {
          "error": {
            "code": 1002,
            "message": "Couldn't find Market with 'id'=anything"
          }
        };

        final client = mockHttp(
            handleRequest: (_) async => Response(json.encode(expectedResult), 404),
            method: 'GET',
            url: '$kBaseUrl/k_with_pending_trades?market=anything&trade_id=1&limit=30&period=1'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        expect(() => omniClient.fetchKWithPendingTrades('anything', 1), throwsA(TypeMatcher<Chopper.Response>()));
      });
    });

    when('parameters are valid', () {
      test('it returns pending trades, which are the trades not included in K data yet', () async {
        final expectedResult = {
          "k": [0],
          "trades": [
            {
              "tid": 0,
              "price": 0,
              "amount": 0,
              "funds": 0,
              "market": "string",
              "created_at": "2019-02-06T13:41:33.647Z",
              "date": "string",
              "side": "string",
              "order_id": "string"
            }
          ]
        };

        final client = mockHttp(
            handleRequest: (_) async => Response(json.encode(expectedResult), 200),
            method: 'GET',
            url: '$kBaseUrl/k_with_pending_trades?market=btcbrl&trade_id=1&limit=30&period=1'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchKWithPendingTrades('btcbrl', 1)).body;
        expect(subject, expectedResult);
      });
    });
  });
}