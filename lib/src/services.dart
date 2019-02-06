import "dart:async";
import 'package:chopper/chopper.dart';

class OmniServices with ChopperServiceMixin {
  OmniServices([ChopperClient client]) {
    this.client = client;
  }

  final definitionType = OmniServices;

  /// Get all available markets.
  Future<Response> fetchMarkets() {
    final url = '/api/v2/markets';
    final request = Request('GET', url);
    return client.send(request);
  }

  /// Get ticker of all markets.
  Future<Response> fetchTickets() {
    final url = '/api/v2/tickers';
    final request = Request('GET', url);
    return client.send(request);
  }

  /// Get ticker of specific market.
  Future<Response> fetchTicketsFromMarket(String market) {
    final url = '/api/v2/tickers/$market';
    final request = Request('GET', url);
    return client.send(request);
  }

  /// Get depth or specified market.
  /// Both asks and bids are sorted from highest price to lowest.
  Future<Response> fetchDepth(String market, {int limit=300}) {
    final url = '/api/v2/depth';
    final params = {'market': market, 'limit': limit};
    final request = Request('GET', url, parameters: params);
    return client.send(request);
  }

  /// Get recent trades on market, each trade is included only once.
  /// Trades are sorted in reverse creation order.
  Future<Response> fetchTrades(String market,
      {int since, int limit, int timestamp, int until, String orderBy}) {
    final url = '/api/v2/trades';
    final params = {
      'market': market,
      'since': since,
      'limit': limit,
      'timestamp': timestamp,
      'until': until,
      'order_by': orderBy
    };
    final request = Request('GET', url, parameters: params);
    return client.send(request);
  }

  /// Get OHLC(k line) of specific market.
  Future<Response> fetchK(String market,
      {int limit, int period=1, int timestamp}) {
    final url = '/api/v2/k';
    final params = {
      'market': market,
      'limit': limit,
      'period': period,
      'timestamp': timestamp
    };
    final request = Request('GET', url, parameters: params);
    return client.send(request);
  }

  /// Get K data with pending trades,
  /// which are the trades not included in K data yet,
  /// because there's delay between trade generated
  /// and processed by K data generator.
  Future<Response> fetchKWithPendingTrades(String market, int tradeId,
      {int limit, int period=1}) {
    final url = '/api/v2/k_with_pending_trades';
    final params = {
      'market': market,
      'trade_id': tradeId,
      'limit': limit,
      'period': period
    };
    final request = Request('GET', url, parameters: params);
    return client.send(request);
  }

  /// Get server current time, in seconds since Unix epoch.
  Future<Response> fetchTimestamp() {
    final url = '/api/v2/timestamp';
    final request = Request('GET', url);
    return client.send(request);
  }

  /// Generate a new Trezor challenge
  Future<Response> generateTrezorChallenge() {
    final url = '/api/v2/trezor/new_challenge';
    final request = Request('GET', url);
    return client.send(request);
  }
}
