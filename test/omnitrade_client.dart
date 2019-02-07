import 'package:test/test.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:http/testing.dart';
import 'dart:convert';
import 'package:http/http.dart';

MockClient mockHttp({MockClientHandler handleRequest, String method, String url}) => MockClient(
  (request) async {
    if (request.toString() == '$method $url') {
      return handleRequest(request);
    }
    return Response('$method $url is different: $request', 404);
  }
);

const String baseUrl = 'https://omnitrade.io/api/v2';

void main() {
  group('fetchMarkets', () {
    test('it returns list with markets', () async {
      final expectedResult = [
        {'id': 'btcbrl', 'name': 'BTC/BRL'}, {'id': 'ltcbrl', 'name': 'LTC/BRL'}
      ];

      final client = mockHttp(
        handleRequest: (_) async => Response(json.encode(expectedResult), 200),
        method: 'GET',
        url: '$baseUrl/markets'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.fetchMarkets()).body;
      expect(subject, expectedResult);
    });
  });

  group('fetchTickets', () {
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
        url: '$baseUrl/tickers'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.fetchTickets()).body;
      expect(subject, expectedResult);
    });
  });

  group('fetchTicketsFromMarket', () {
    group('when market is invalid', () {
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
          url: '$baseUrl/tickers/anything'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        expect(omniClient.fetchTicketsFromMarket('anything'), throws);
      });
    });

    group('when market valid', () {
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
          url: '$baseUrl/tickers/btcbrl'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchTicketsFromMarket('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });

  group('fetchDepth', () {
    group('when market is invalid', () {
      test('it returns empty asks and bids', () async {
        final expectedResult = {
          "timestamp": 1549463516,
          "asks": [],
          "bids": []
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$baseUrl/depth?market=anything&limit=300'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchDepth('anything')).body;
        expect(subject, expectedResult);
      });
    });

    group('when market valid', () {
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
          url: '$baseUrl/depth?market=btcbrl&limit=300'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchDepth('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });

  group('fetchTrades', () {
    group('when market is invalid', () {
      test('it returns empty list', () async {
        final expectedResult = [];

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$baseUrl/trades?market=anything&since=null&limit=null&timestamp=null&until=null&order_by=null'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchTrades('anything')).body;
        expect(subject, expectedResult);
      });
    });

    group('when market valid', () {
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
          url: '$baseUrl/trades?market=btcbrl&since=null&limit=null&timestamp=null&until=null&order_by=null'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchTrades('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });

  group('fetchK', () {
    group('when market is invalid', () {
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
          url: '$baseUrl/k?market=anything&limit=null&period=1&timestamp=null'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        expect(omniClient.fetchK('anything'), throws);
      });
    });

    group('when market valid', () {
      test('it returns list with OHLC(k line) of specific market', () async {
        final expectedResult = [
          [
            1549469940,
            12700,
            12700,
            12700,
            12700,
            0
          ],
        ];

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$baseUrl/k?market=btcbrl&limit=null&period=1&timestamp=null'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchK('btcbrl')).body;
        expect(subject, expectedResult);
      });
    });
  });

  group('fetchKWithPendingTrades', () {
    group('when market is invalid', () {
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
          url: '$baseUrl/k_with_pending_trades?market=anything&trade_id=1&limit=null&period=1'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        expect(omniClient.fetchKWithPendingTrades('anything', 1), throws);
      });
    });

    group('when parameters are valid', () {
      test('it returns pending trades, which are the trades not included in K data yet', () async {
        final expectedResult = {
          "k": [
            0
          ],
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
          url: '$baseUrl/k_with_pending_trades?market=btcbrl&trade_id=1&limit=null&period=1'
        );

        final omniClient = OmniTradeClient(httpClient: client);
        final subject = (await omniClient.fetchKWithPendingTrades('btcbrl', 1)).body;
        expect(subject, expectedResult);
      });
    });
  });

  group('fetchTimestamp', () {
    test('it returns server current time', () async {
      final expectedResult = 1549472661;

      final client = mockHttp(
        handleRequest: (_) async => Response(json.encode(expectedResult), 200),
        method: 'GET',
        url: '$baseUrl/timestamp'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.fetchTimestamp()).body;
      expect(subject, expectedResult);
    });
  });


  group('generateTrezorChallenge', () {
    test('it returns a new Trezor challenge', () async {
      final expectedResult = {
        "visual": "2019-02-06T13:41:33.678Z",
        "hidden": "string"
      };

      final client = mockHttp(
        handleRequest: (_) async => Response(json.encode(expectedResult), 200),
        method: 'GET',
        url: '$baseUrl/trezor/new_challenge'
      );

      final omniClient = OmniTradeClient(httpClient: client);
      final subject = (await omniClient.generateTrezorChallenge()).body;
      expect(subject, expectedResult);
    });
  });
}
