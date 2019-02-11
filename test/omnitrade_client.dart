import 'package:test/test.dart';
import 'package:omnitrade_client/omnitrade_client.dart';
import 'package:omnitrade_client/src/helpers/injector.dart';
import 'helper.dart';


void main() {
  setUpAll(() {
    Injector.configure(kBaseUrl.contains('staging') ? Env.PROD : Env.TEST);
  });

  describe('OmniCredentials.isPublicAccess', () {
    when('not provided keys', () {
      test('it returns true', () {
        final subject = OmniCredentials().isPublicAccess;
        expect(subject, isTrue);
      });
    });

    when('provided keys', () {
      test('it returns false', () {
        final subject = OmniCredentials(
          accessKey: 'xxx',
          privateKey: 'yyy'
        ).isPublicAccess;

        expect(subject, isFalse);
      });
    });
  });
}
