import 'package:get/get.dart';
import 'package:kmsmerino/helper/network_connectivity_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
