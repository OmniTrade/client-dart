import 'dart:convert';
import 'package:test/test.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:chopper/chopper.dart' as Chopper show Response;
import 'package:omnitrade_client/src/helpers/injector.dart';
import 'package:http/http.dart';
import '../../helper.dart';

void main() {
  setUpAll(() {
    Injector.configure(kBaseUrl.contains('staging') ? Env.PROD : Env.TEST);
  });

  describe('fetchDeposits', () {
    when('user provide credentials', () {
      test('it returns deposits history', () async {
        final expectedResult = [
          {
            "id": 0,
            "currency": "brl",
            "amount": 0,
            "fee": 0,
            "txid": 0,
            "created_at": "2019-02-11T10:35:36.154Z",
            "confirmations": "string",
            "done_at": "2019-02-11T10:35:36.154Z",
            "state": "checked"
          }
        ];

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/deposits?access_key=xxx&currency&limit=1&state&tonce=123456789&signature=0375d7dbadc653d5b36042525466c46ba7e2736d3dc4894941060a3412ad9286'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.fetchDeposits()).body;
        expect(subject, expectedResult);
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(omniClient.fetchMe, throwsA(TypeMatcher<Exception>()));
      });
    });
  });

  describe('fetchDeposit', () {
    when('exist deposit', () {
      test('it returns deposit details', () async {
        final expectedResult = {
          "id": 0,
          "currency": "brl",
          "amount": 0,
          "fee": 0,
          "txid": 0,
          "created_at": "2019-02-11T10:35:36.154Z",
          "confirmations": "string",
          "done_at": "2019-02-11T10:35:36.154Z",
          "state": "checked"
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/deposit?access_key=xxx&txid=1&tonce=123456789&signature=812761e4ba9d355d738d2cae31ce4a18b7d4f9f46f68215ef824141ac0d76e14'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.fetchDeposit('1')).body;
        expect(subject, expectedResult);
      });
    });

    when('not found deposit', () {
      test('it returns http error 404', () async {
        final expectedResult = {
          "code": 0,
          "status": 404,
          "message": "string"
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 404),
          method: 'GET',
          url: '$kBaseUrl/deposit?access_key=xxx&txid=1&tonce=123456789&signature=c67568e50cd4c829a1d1c77df2fb550eaea03748f582aab618fdf51700ece6b7'
        );
        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        expect(omniClient.fetchDeposit('1'), throwsA(TypeMatcher<Chopper.Response>()));
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(() => omniClient.fetchDeposit('1'), throwsA(TypeMatcher<Exception>()));
      });
    });
  });

  describe('fetchDepositAddress', () {
    when('provided credentials', () {
      test('it returns deposits address', () async {
        final expectedResult = {
          'address': 'mrAqofBkTgz5zFmB3wq6X1w9233mkou43f'
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/deposit_address?access_key=xxx&currency=bch&tonce=123456789&signature=94389f4cd20f45ba06893b1e2a13ea49fac5117c0961b10b93aa3b78085f1638'
        );
        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.fetchDepositAddress('bch')).body;
        expect(subject, expectedResult);
      });
    });
  });

  describe('fetchMe', () {
    when('user provide credentials', () {
      test('it returns profile account info', () async {
        final expectedResult = {
          'sn': 'your_unique_id',
          'name': 'Your name',
          'email': 'your@mail.com',
          'activated': true,
          'accounts': [
            {'currency': 'btc', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'ltc', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'btg', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'dash', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'bch', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'eth', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'dcr', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'brl', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'xrp', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'mft', 'balance': '0.0', 'locked': '0.0'},
            {'currency': 'usdc', 'balance': '0.0', 'locked': '0.0'}
          ]
        };

        final client = mockHttp(
          handleRequest: (_) async => Response(json.encode(expectedResult), 200),
          method: 'GET',
          url: '$kBaseUrl/members/me?access_key=xxx&tonce=123456789&signature=4a94c2c644977f1d0eb308611cbffbcd9119733b036e2b75650290cd51c3338d'
        );

        final omniClient = OmniTradeClient(httpClient: client, credentials: credentials);
        final subject = (await omniClient.fetchMe()).body;
        expect(subject, expectedResult);
      });
    });

    when('user not provide crendetials', () {
      test('it throws error', () async {
        final omniClient = OmniTradeClient();
        expect(omniClient.fetchMe, throwsA(TypeMatcher<Exception>()));
      });
    });
  });
}
