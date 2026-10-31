import 'package:kmsmerino/services/api/api_client.dart';
import 'package:kmsmerino/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(
    sharedPreferences,
    permanent: true,
  ); // Make it permanent so it's always available
  Get.put(ApiClient(sharedPreferences: Get.find()));

  // Controller
  Get.put(AuthController(apiClient: Get.find(), sharedPreferences: Get.find()));
}
