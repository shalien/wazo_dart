import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:wazo_dart/wazo_dart.dart';

void main() {
  group('Wazo Auth - Token Tests', () {
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
    });

    test('Get token', () async {
      final response = await client.auth.createToken(username, password);

      token = response['data']['token'];
      client.token = token;

      expect(token, isNotNull);
    });

    test('Check is token is valid for auth.users.create', () async {
      final response =
          await client.auth.isTokenValid(token, scope: 'auth.users.create');

      print('$response');

      expect(response, isTrue);
    });

    test('Check is token is valid for auth.users.read', () async {
      final response =
          await client.auth.isTokenValid(token, scope: 'auth.users.read');

      expect(response, isTrue);
    });
  });
}
