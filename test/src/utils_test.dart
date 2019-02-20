import 'package:test/test.dart';
import 'package:omnitrade_client/src/helpers/utils.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:chopper/chopper.dart';

void main() {
  final OmniCredentials credentials = OmniCredentials(
    accessKey: 'xxx',
    privateKey: 'yyy'
  );

  group('mapToQueryParameter', () {
    group('when encoding only one argument', () {
      test('it returns query paramater without concat symbol', () {
        final mapData = {'id': '1'};
        final queryParameter = mapToQueryParameter(mapData);

        expect(queryParameter, 'id=1');
      });
    });

    group('when encoding serveral arguments', () {
      test('it returns query paramater with concat symbol', () {
        final mapData = {'id': '1', 'user_id': '1'};
        final queryParameter = mapToQueryParameter(mapData);

        expect(queryParameter, 'id=1&user_id=1');
      });
    });

    group('when encoding non strings arguments', () {
      test('it returns query paramater encoded', () {
        final mapData = {
          'id': 1, 'user': { 'id': 1 }, 'another': ['str1', 'str2']
        };
        final queryParameter = mapToQueryParameter(mapData);

        expect(
          queryParameter,
          'another=%5Bstr1%2C%20str2%5D&id=1&user=%7Bid%3A%201%7D'
        );
      });
    });
  });

  group('.generateSignature', () {
    group('when http verd is GET', () {
      test('it returns correct signature', () {
        final request = Request('GET', '/markets', parameters: {
          'access_key': credentials.accessKey,
          'foo': 'bar',
          'tonce': '123456789'
        });
        final signature = generateSignature(request, credentials);

        expect(signature, 'e324059be4491ed8e528aa7b8735af1e96547fbec96db962d51feb7bf1b64dee');
      });
    });

    group('when http verb is POST', () {
      test('it returns correct signature', () {
        final request = Request('POST', '/markets', parameters: {
          'tonce': '123456789',
          'access_key': credentials.accessKey
        });
        final signature = generateSignature(request, credentials);

        expect(signature, '458c61feaf71d6a405c476fc41b7ba55050c53fe9d850931da81dd6d964acf47');
      });
    });
  });
}
