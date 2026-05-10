import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../services/database_service.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class StudentHomeController extends GetxController {
  final DatabaseService _db = DatabaseService();

  final Rx<UserModel?> admin = Rx<UserModel?>(null);
  final RxBool isLoading = true.obs;

  String get _myUid =>
      Get.find<AuthController>().currentUser.value?.uid ??
      FirebaseAuth.instance.currentUser?.uid ??
      '';

  @override
  void onInit() {
    super.onInit();
    _db.adminUser().listen((adminUser) {
      admin.value = adminUser;
      isLoading.value = false;
    });
    _db.updateLastSeen(_myUid);
  }

  void openChatWithAdmin() {
    final adminUser = admin.value;
    if (adminUser == null) return;
    final cId = ChatModel.buildChatId(_myUid, adminUser.uid);
    Get.toNamed(AppRoutes.chatRoom, arguments: {
      'chatId': cId,
      'otherName': adminUser.displayName,
      'otherUid': adminUser.uid,
    });
  }
}
