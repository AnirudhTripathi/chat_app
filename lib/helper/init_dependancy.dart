import 'package:chat_app/viewmodel/controllers/auth_controller.dart';
import 'package:get/get.dart';

class InitDependancy {
 static void init() {
    Get.put(AuthController());
  }


}
