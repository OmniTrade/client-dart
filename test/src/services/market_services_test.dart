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

  describe('fetchMarkets', () {
    test('it returns list with markets', () async {
      final expectedResult = [
        {'id': 'btcbrl', 'name': 'BTC/BRL'},
        {'id': 'ltcbrl', 'name': 'LTC/BRL'}
      ];

      final client = mockHttp(
        handleRequest: (_) async => Response(json.encode(expectedResult), 200),
        method: 'GET',
        url: '$kBaseUrl/markets'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.fetchMarkets()).body;
      expect(subject, expectedResult);
    });
  });

  describe('fetchTickets', () {
    test('it returns list with tickets', () async {
      final expectedResult = {
        'btcbrl': {
          'at': 1549462003,
          'ticker': {
            'buy': 12510.53,
            'sell': 13125.0,
            'low': 12510.01,
            'high': 12680.0,
            'last': 12510.53,
            'open': 12660.0,
            'vol': '4.04069023'
          }
        }
      };

      final client = mockHttp(
        handleRequest: (_) async => Response(json.encode(expectedResult), 200),
        method: 'GET',
        url: '$kBaseUrl/tickers'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.fetchTickets()).body;
      expect(subject, expectedResult);
    });
  });

  describe('fetchTicketsFromMarket', () {
    when('market is invalid', () {
      test('it returns status 404', () {
        final expectedResult = {
          "error": {
            "code": 1002,
            "message": "Market Not Found"
          }
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 404),
          method: 'GET',
          url: '$kBaseUrl/tickers/anything'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        expect(omniClient.fetchTicketsFromMarket('anything'), throwsA(TypeMatcher<Chopper.Response>()));
      });
    });

    when('market valid', () {
      test('it returns ticket of market', () async {
        final expectedResult = {
          "at": 1549463003,
          "ticker": {
            "buy": 12510.42,
            "sell": 13125,
            "low": 12510.01,
            "high": 12680,
            "last": 12510.42,
            "open": 12660,
            "vol": "4.06360181"
          }
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/tickers/btcbrl'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchTicketsFromMarket('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });

  describe('fetchDepth', () {
    when('market is invalid', () {
      test('it returns empty asks and bids', () async {
        final expectedResult = {
          "timestamp": 1549463516,
          "asks": [],
          "bids": []
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/depth?market=anything&limit=300'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchDepth('anything')).body;
        expect(subject, expectedResult);
      });
    });

    when('market valid', () {
      test('it returns asks and bids', () async {
        final expectedResult = {
          "timestamp": 1549470778,
          "asks": [
            ["40000.0","0.06811832"]
          ],
          "bids": [
            ["12700.0","0.02401336"],
          ]};

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/depth?market=btcbrl&limit=300'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchDepth('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });

  describe('fetchTrades', () {
    when('market is invalid', () {
      test('it returns empty list', () async {
        final expectedResult = [];

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/trades?market=anything&since=null&limit=null&timestamp=null&until=null&order_by=null'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchTrades('anything')).body;
        expect(subject, expectedResult);
      });
    });

    when('market valid', () {
      test('it returns list with recent trades', () async {
        final expectedResult = [
          {
            "tid": 1618491,
            "price": "12700.0",
            "amount": "0.00315992",
            "funds": "40.130984",
            "market": "btcbrl",
            "created_at": "2019-02-06T14:42:51-02:00",
            "date": 1549471371,
            "side": null
          },
        ];

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/trades?market=btcbrl&since=null&limit=null&timestamp=null&until=null&order_by=null'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchTrades('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });
}
