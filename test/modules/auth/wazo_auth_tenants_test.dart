import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:wazo_dart/wazo_dart.dart';

void main() {
  group('Wazo Auth - Tenants Tests', () {
    late String host;
    late String username;
    late String password;
    late String token;

    late WazoClient client;
    String tenantUuid = '45b35cb8-2505-4745-bff3-81263ce17bf2';

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

    test('Get all tenants', () async {
      late Map response;

      try {
        response = await client.auth.tenants.getTenants();
      } on WazoException catch (e) {
        print('${e.code} ${e.details}');
      }

      expect(response, isMap);
    });

    test('Get all tenant users', () async {
      late Map response;

      try {
        response =
            await client.auth.users.getUsers(offset: 0, wazoTenant: tenantUuid);
      } on WazoException catch (e) {
        print('${e.code} ${e.details}');
      }
      print(response);

      expect(response, isMap);
    });
  });
}
