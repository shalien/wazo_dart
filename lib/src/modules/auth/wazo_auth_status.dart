import '../../wazo_exception.dart';
import '../wazo_module.dart';

class WazoAuthStatus extends WazoModule {
  WazoAuthStatus(WazoModule parent) : super.fromParent(parent);

  /// Check if `wazo-auth` is OK
  Future<bool> status() async {
    final uri = Uri.parse(formatUrl('status'));

    final response = await httpClient.head(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        throw WazoException.fromResponse(response);
    }
  }
}
