import "dart:async";
import 'package:chopper/chopper.dart';
import '../services.dart';

abstract class DepositServices implements OmniTradeServicePrivate {
  /// Get your deposits history
  Future<Response> fetchDeposits({String currency='', int limit=1, String state=''}) {
    final path = '/deposits';
    final params = {
      'currency': currency,
      'limit': limit,
      'state': state,
    };
    final request = Request('GET', path, parameters: params);
    return execPrivate(request);
  }

  /// Get details of specific deposit
  Future<Response> fetchDeposit(String txid) {
    final path = '/deposit';
    final params = { 'txid': txid };
    final request = Request('GET', path, parameters: params);
    return execPrivate(request);
  }

  /// Where to deposit.
  /// The address field could be empty when a new address is generating (e.g. for bitcoin)
  Future<Response> fetchDepositAddress(String currency) {
    final path = '/deposit_address';
    final params = { 'currency': currency };
    final request = Request('GET', path, parameters: params);
    return execPrivate(request);
  }

  /// Get your profile and accounts info
  Future<Response> fetchMe() {
    final path = '/members/me';
    final request = Request('GET', path);
    return execPrivate(request);
  }
}
