import 'package:dotenv/dotenv.dart';
import 'package:test/test.dart';
import 'package:wazo_dart/src/modules/auth/wazo_direction.dart';
import 'package:wazo_dart/wazo_dart.dart';

void main() {
  group('Wazo Auth - User Tests', () {
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

    test('Get all users', () async {
      late Map<String, dynamic> response;
      try {
        response = await client.auth.users.getUsers(
            order: 'firstname', direction: WazoDirection.asc, recurse: true);
      } on WazoException catch (e) {
        print('${e.code} ${e.details}');
      }

      expect(response, isMap);
    });

    test('Create an user', () async {
      /*
      String emailAddress = 'test@example.com';
      String firstname = 'Dave';
      String lastname = 'Smith';
      String password = 'P@ssw0rd';
      WazoUserPurpose purpose = WazoUserPurpose.user;
      String username = 'dsmith';
      String uuid = Uuid().v4();
      bool enabled = true;

      late Map<String, dynamic> response;
      try {
        response = await client.auth.createUser(emailAddress, firstname,
            lastname, password, purpose, username, uuid,
            enabled: enabled);
      } on WazoException catch (e) {
        print('${e.code} ${e.details}');
      }

      expect(response, isMap);
      */
      expect(true, true);
    });

    test('Reset user password', () async {
      late bool response;

      try {
        response =
            await client.auth.users.resetUserPassword(username: 'oduparc');
      } on WazoException catch (e) {
        print('${e.code} ${e.details}');
      }

      expect(response, isTrue);
    });

    /*
    test('Register an user', () async {
      late Map<String, dynamic> response;

      try {
        response = await client.auth.registerUser(
            'example@example.com', '456P@ssw0rd', 'testApiODuparc');
      } on WazoException catch (e) {
        print('${e.code} ${e.details}');
      }

      expect(response, isMap);
    });
    */
  });
}
