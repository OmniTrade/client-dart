import 'dart:convert';
import 'package:omnitrade_client/src/models/order.dart';
import 'package:test/test.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:chopper/chopper.dart' as Chopper show Response;
import 'package:omnitrade_client/src/helpers/injector.dart';
import 'package:http/http.dart';
import '../../helper.dart';

void main() {
  final fakeOrder = Order('brl', OrderSide.buy, '1.0');

  setUpAll(() {
    Injector.configure(kBaseUrl.contains('staging') ? Env.PROD : Env.TEST);
  });

  describe('fetchOrders', () {
    when('provided credentials and user has no orders', () {
      test('it returns list of orders', () async {
        final expectedResult = [];

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/orders?access_key=xxx&market=brlbtc&state=null&limit=100&page=1&orderBy=asc&tonce=123456789&signature=3114c5f8f463c277313651f419857104a0cf672f90dde34e385b0eedacb10cb6'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.fetchOrders('brlbtc')).body;
        expect(subject, expectedResult);
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(() => omniClient.fetchOrders('brltbc'), throwsA(TypeMatcher<Exception>()));
      });
    });
  });

  describe('createOrder', () {
    when('provided credentials and user has no orders', () {
      test('it returns list of orders', () async {
        final expectedResult = {
          "id": 0,
          "side": "string",
          "ord_type": "string",
          "price": 0,
          "avg_price": 0,
          "state": "string",
          "market": "string",
          "created_at": "string",
          "volume": 0,
          "remaining_volume": 0,
          "executed_volume": 0,
          "trades_count": "string",
          "trades": "string"
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'POST',
          url: '$kBaseUrl/orders?access_key=xxx&tonce=123456789&signature=389d5b84dc95398805de7b118124d7bf7dc8ea1a1f8d9100a3d6b2e9411b67bf'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.createOrder(fakeOrder)).body;
        expect(subject, expectedResult);
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(() => omniClient.createOrder(fakeOrder), throwsA(TypeMatcher<Exception>()));
      });
    });
  });

  describe('createManyOrders', () {
    test('it throws unimplement error', () {
      final omniClient = OmniTradeClient();
      expect(() => omniClient.createManyOrders([fakeOrder]), throwsA(TypeMatcher<UnimplementedError>()));
    });
  });

  describe('cancelOrders', () {
    when('user provide credentials', () {
      test('it cancel the order', () async {
        final expectedResult = {
          "id": 0,
          "side": "string",
          "ord_type": "string",
          "price": 0,
          "avg_price": 0,
          "state": "string",
          "market": "string",
          "created_at": "string",
          "volume": 0,
          "remaining_volume": 0,
          "executed_volume": 0,
          "trades_count": "string",
          "trades": "string"
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'POST',
          url: '$kBaseUrl/orders/clear?access_key=xxx&tonce=123456789&signature=f0af3e862a2fe1a05551d4a748c99078210e4ec7c03abf2166ab5112029357aa'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.cancelOrders()).body;
        expect(subject, expectedResult);
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(() => omniClient.cancelOrders(), throwsA(TypeMatcher<Exception>()));
      });
    });
  });

  describe('cancelOrdersBottom', () {
    test('it throws unimplement error', () {
      final omniClient = OmniTradeClient();
      expect(() => omniClient.createManyOrders([fakeOrder]), throwsA(TypeMatcher<UnimplementedError>()));
    });
  });

  describe('fetchOrder', () {
    when('user provide credentials', () {
      test('it returns details of order', () async {
        final expectedResult = {
          "id": 0,
          "side": "string",
          "ord_type": "string",
          "price": 0,
          "avg_price": 0,
          "state": "string",
          "market": "string",
          "created_at": "string",
          "volume": 0,
          "remaining_volume": 0,
          "executed_volume": 0,
          "trades_count": "string",
          "trades": "string"
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/order?access_key=xxx&id=1&tonce=123456789&signature=bcb598f31dc078fb0a98b761df8bd60bc7baf34b0f712650c9ede4e655b1d14b'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.fetchOrder(1)).body;
        expect(subject, expectedResult);
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(() => omniClient.fetchOrder(1), throwsA(TypeMatcher<Exception>()));
      });
    });
  });

  describe('cancelOrder', () {
    when('user provide credentials', () {
      test('it returns details of order', () async {
        final expectedResult = {
          "id": 0,
          "side": "string",
          "ord_type": "string",
          "price": 0,
          "avg_price": 0,
          "state": "string",
          "market": "string",
          "created_at": "string",
          "volume": 0,
          "remaining_volume": 0,
          "executed_volume": 0,
          "trades_count": "string",
          "trades": "string"
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'POST',
          url: '$kBaseUrl/order/delete?access_key=xxx&tonce=123456789&signature=0121c32168116374f69bd263ff6d96108f35d6d61fc0277e4af25226015ecf3c'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.cancelOrder(1)).body;
        expect(subject, expectedResult);
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(() => omniClient.cancelOrder(1), throwsA(TypeMatcher<Exception>()));
      });
    });
  });
}
