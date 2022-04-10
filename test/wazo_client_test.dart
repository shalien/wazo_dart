import 'package:dotenv/dotenv.dart';
import 'package:wazo_dart/src/wazo_client.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late String host;
    late String username;
    late String password;
    late String token;

    late WazoClient client;

    setUp(() {
      load();
      host = env['HOST'].toString();
      username = env['USERNAME'].toString();
      password = env['PASSWORD'].toString();
    });

    test('Create Client', () {
      client = WazoClient(host);
      expect(client, isNotNull);
    });

    test('Get Token', () async {
      final response = await client.auth.token.createToken(username, password);
      token = response['data']['token'];
      expect(token, isNotNull);
    });

    test('Is Token Valid', () async {
      final response = await client.auth.token.isTokenValid(token);

      print(response);

      expect(true, true);
    });
  });
}
