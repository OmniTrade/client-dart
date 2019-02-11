import "dart:async";
import 'package:chopper/chopper.dart';
import '../services.dart';

abstract class MarketServices implements OmniTradeService {
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
}