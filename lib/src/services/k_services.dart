import "dart:async";
import 'package:chopper/chopper.dart';
import '../services.dart';

abstract class KServices implements OmniTradeService {
  /// Get OHLC(k line) of specific market.
  Future<Response> fetchK(String market,
      {int limit=30, int period=1, int timestamp}) {
    final path = '/k';
    final params = {
      'market': market,
      'limit': limit,
      'period': period,
      'timestamp': timestamp ?? ''
    };
    final request = Request('GET', path, parameters: params);
    return client.send(request);
  }

  /// Get K data with pending trades,
  /// which are the trades not included in K data yet,
  /// because there's delay between trade generated
  /// and processed by K data generator.
  Future<Response> fetchKWithPendingTrades(String market, int tradeId,
      {int limit=30, int period=1}) {
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
}