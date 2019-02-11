import "dart:async";
import 'package:chopper/chopper.dart';
import '../models/order.dart';
import '../services.dart';

abstract class OrderServices implements OmniTradeServicePrivate {
  /// Get your orders, results is paginated.
  Future<Response> fetchOrders(String market,
      {String state, int limit=100, int page=1, String orderBy='asc'}) {
    final path = '/orders';
    final params = {
      'market': market,
      'state': state,
      'limit': limit,
      'page': page,
      'orderBy': orderBy,
    };
    final request = Request('GET', path, parameters: params);
    return execPrivate(request);
  }

  /// Create a Sell/Buy order
  /// side can be 'sell' or 'buy'
  /// ordType can be 'limit' or 'market'
  Future<Response> createOrder(Order order) {
    final path = '/orders';
    final request = Request('POST', path, body: order.asMap);
    return execPrivate(request);
  }

  /// Similar of [createOrder] but receive a list of orders to create
  Future<Response> createManyOrders(List<Order> orders) {
    throw UnimplementedError('Todo implement this method');
  }

  /// Cancel all my orders.
  Future<Response> cancelOrders({String market, OrderSide side}) {
    final path = '/orders/clear';
    final params = {
      'market': market,
      'side': '$side'.substring('$side'.indexOf('.') + 1)
    };
    final request = Request('POST', path, body: params);
    return execPrivate(request);
  }

  /// Similar of [cancelOrders] but instead cancel all, cancel only
  /// most expensive buys and cheapest sells
  Future<Response> cancelOrdersBottom({String market, OrderSide side}) {
    throw UnimplementedError('Todo implement this method');
  }

  /// Get information of specified order.
  Future<Response> fetchOrder(int orderId) {
    final path = '/order';
    final params = {
      'id': orderId
    };
    final request = Request('GET', path, parameters: params);
    return execPrivate(request);
  }

  /// Get information of specified order.
  Future<Response> cancelOrder(int orderId) {
    final path = '/order/delete';
    final params = {
      'id': orderId
    };
    final request = Request('POST', path, body: params);
    return execPrivate(request);
  }
}