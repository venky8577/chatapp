import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/users/users_list_screen.dart';
import '../screens/common/chat_room_screen.dart';
import '../controllers/login_controller.dart';
import '../controllers/users_list_controller.dart';
import '../controllers/chat_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => LoginController(), fenix: true)),
    ),
    GetPage(
      name: AppRoutes.usersList,
      page: () => const UsersListScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => UsersListController(), fenix: true)),
    ),
    GetPage(
      name: AppRoutes.chatRoom,
      page: () => const ChatRoomScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => ChatController(), fenix: true)),
    ),
  ];
}
