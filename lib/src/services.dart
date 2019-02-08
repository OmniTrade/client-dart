import "dart:async";
import 'package:chopper/chopper.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:omnitrade_client/src/utils.dart';

abstract class OmniTradePrivate {
  Future<Response> _execPrivate(Request request);
}

class OmniServices with ChopperServiceMixin implements OmniTradePrivate {
  OmniServices([ChopperClient client]) {
    this.client = client;
  }

  OmniCredentials credentials;
  final definitionType = OmniServices;

  /// Get all available markets.
  Future<Response> fetchMarkets() {
    final path = '/markets';
    final request = Request('GET', path);
    return client.send(request);
  }

  /// Get ticker of all markets.
  Future<Response> fetchTickets() {
    final path = '/tickers';
    final request = Request('GET', path);
    return client.send(request);
  }

  /// Get ticker of specific market.
  Future<Response> fetchTicketsFromMarket(String market) {
    final path = '/tickers/$market';
    final request = Request('GET', path);
    return client.send(request);
  }

  /// Get depth or specified market.
  /// Both asks and bids are sorted from highest price to lowest.
  Future<Response> fetchDepth(String market, {int limit=300}) {
    final path = '/depth';
    final params = {'market': market, 'limit': limit};
    final request = Request('GET', path, parameters: params);
    return client.send(request);
  }

  /// Get recent trades on market, each trade is included only once.
  /// Trades are sorted in reverse creation order.
  Future<Response> fetchTrades(String market,
      {int since, int limit, int timestamp, int until, String orderBy}) {
    final path = '/trades';
    final params = {
      'market': market,
      'since': since,
      'limit': limit,
      'timestamp': timestamp,
      'until': until,
      'order_by': orderBy
    };
    final request = Request('GET', path, parameters: params);
    return client.send(request);
  }

  /// Get OHLC(k line) of specific market.
  Future<Response> fetchK(String market,
      {int limit, int period=1, int timestamp}) {
    final path = '/k';
    final params = {
      'market': market,
      'limit': limit,
      'period': period,
      'timestamp': timestamp
    };
    final request = Request('GET', path, parameters: params);
    return client.send(request);
  }

  /// Get K data with pending trades,
  /// which are the trades not included in K data yet,
  /// because there's delay between trade generated
  /// and processed by K data generator.
  Future<Response> fetchKWithPendingTrades(String market, int tradeId,
      {int limit, int period=1}) {
    final path = '/k_with_pending_trades';
    final params = {
      'market': market,
      'trade_id': tradeId,
      'limit': limit,
      'period': period
    };
    final request = Request('GET', path, parameters: params);
    return client.send(request);
  }

  /// Get server current time, in seconds since Unix epoch.
  Future<Response> fetchTimestamp() {
    final path = '/timestamp';
    final request = Request('GET', path);
    return client.send(request);
  }

  /// Generate a new Trezor challenge
  Future<Response> generateTrezorChallenge() {
    final path = '/trezor/new_challenge';
    final request = Request('GET', path);
    return client.send(request);
  }

  /// Generate a new Trezor challenge
  Future<Response> fetchMe() {
    final path = '/members/me';
    final request = Request('GET', path);
    return _execPrivate(request);
  }

  Future<Response> _execPrivate(Request request) {
    final parameters = <String, dynamic>{};
    parameters
      ..addAll(request.parameters)
      ..addAll({
        'access_key': credentials.accessKey,
        'tonce': '$tonce'
      });

    final signature = generateSignature(
      request.replace(parameters: parameters),
      credentials
    );

    parameters.addAll({'signature': signature});
    return client.send(request.replace(parameters: parameters));
  }
}

