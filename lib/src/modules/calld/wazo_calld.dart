import 'wazo_calld_status.dart';

import '../../wazo_client.dart';

import '../wazo_module.dart';

class WazoCalld extends WazoModule {
  WazoCalld(WazoClient wazoClient) : super(wazoClient, 'calld', '1.0');

  WazoCalldStatus get status => WazoCalldStatus(this);
}
