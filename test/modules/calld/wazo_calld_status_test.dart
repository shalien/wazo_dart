import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:wazo_dart/wazo_dart.dart';

void main() {
  group('Wazo Calld - Status Tests', () {
    late String host;
    late String username;
    late String password;
    late String token;

    late WazoClient client;

    setUp(() async {
      load();
      host = env['HOST'].toString();
      username = env['USERNAME'].toString();
      password = env['PASSWORD'].toString();
      client = WazoClient(host);
      final response = await client.auth.token.createToken(username, password);

      token = response['data']['token'];
      client.apiToken = token;
    });

    test('Get status', () async {
      late Map response;

      try {
        response = await client.calld.status.getStatus();
      } on WazoException catch (e) {
        print('${e.code} ${e.details}');
      }
      print(response);

      expect(response, isMap);
    });
  });
}
