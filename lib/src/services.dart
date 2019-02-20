import "dart:async";
import 'package:chopper/chopper.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:omnitrade_client/src/helpers/utils.dart';
import 'services/order_services.dart';
import 'services/k_services.dart';
import 'services/deposit_services.dart';
import 'services/market_services.dart';
import 'services/others_services.dart';

abstract class OmniTradeServicePrivate implements OmniTradeService {
  Future<Response> execPrivate(Request request);
}

abstract class OmniTradeService {
  OmniCredentials credentials;
  ChopperClient client;
  final definitionType = OmniServices;
}

class OmniServices with ChopperServiceMixin,
                        OrderServices,
                        KServices,
                        DepositServices,
                        MarketServices,
                        OthersServices
                        implements OmniTradeServicePrivate  {
  OmniServices([ChopperClient client]) {
    this.client = client;
  }

  OmniCredentials credentials;
  final definitionType = OmniServices;

  Future<Response> execPrivate(Request request) {
    if (credentials.isPublicAccess) throw Exception('You must provide your credentials to use this call');

    final parameters = <String, dynamic>{};
    parameters
      ..addAll({'access_key': credentials.accessKey})
      ..addAll(request.parameters)
      ..addAll({'tonce': '$tonce'});

    final signature = generateSignature(
      request.replace(parameters: parameters),
      credentials
    );

    parameters.addAll({'signature': signature});
    return client.send(request.replace(parameters: parameters));
  }
}

