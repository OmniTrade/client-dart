import "dart:async";
import 'package:chopper/chopper.dart';
import '../services.dart';

abstract class OthersServices implements OmniTradeService {
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
}
