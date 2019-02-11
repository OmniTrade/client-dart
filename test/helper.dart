import 'package:http/testing.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

MockClient mockHttp(
  {MockClientHandler handleRequest, String method, String url}) => MockClient(
  (request) async {
    if (request.toString() == '$method $url') {
      return handleRequest(request);
    }
    return Response('$method $url is different: $request', 404);
  }
);

final credentials = OmniCredentials(
  accessKey: kBaseUrl.contains('staging') ? 'ACCESS_KEY' : 'xxx',
  privateKey: kBaseUrl.contains('staging') ? 'PRIVATE_KEY' : 'yyy',
);

void when(String context, Function body) => group('when $context', body);
void describe(String element, Function body) => group('.$element', body);
