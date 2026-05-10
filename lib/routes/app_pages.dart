import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/setup_name_screen.dart';
import '../screens/student/student_home_screen.dart';
import '../screens/admin/admin_home_screen.dart';
import '../screens/common/chat_room_screen.dart';
import '../controllers/otp_controller.dart';
import '../controllers/setup_name_controller.dart';
import '../controllers/student_home_controller.dart';
import '../controllers/admin_home_controller.dart';
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
      page: () => const PhoneLoginScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => OtpController(), fenix: true)),
    ),
    GetPage(
      name: AppRoutes.setupName,
      page: () => const SetupNameScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => SetupNameController(), fenix: true)),
    ),
    GetPage(
      name: AppRoutes.studentHome,
      page: () => const StudentHomeScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => StudentHomeController(), fenix: true)),
    ),
    GetPage(
      name: AppRoutes.adminHome,
      page: () => const AdminHomeScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => AdminHomeController(), fenix: true)),
    ),
    GetPage(
      name: AppRoutes.chatRoom,
      page: () => const ChatRoomScreen(),
      binding: BindingsBuilder(
          () => Get.lazyPut(() => ChatController(), fenix: true)),
    ),
  ];
}
