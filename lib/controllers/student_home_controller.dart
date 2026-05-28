import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../services/database_service.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class StudentHomeController extends GetxController {
  final DatabaseService _db = DatabaseService();

  final RxList<UserModel> admins = <UserModel>[].obs;
  final RxBool isLoading = true.obs;

  String get _myUid =>
      Get.find<AuthController>().currentUser.value?.uid ??
      FirebaseAuth.instance.currentUser?.uid ??
      '';

  @override
  void onInit() {
    super.onInit();
    _db.adminUsers().listen((list) {
      admins.value = list;
      isLoading.value = false;
    });
    _db.updateLastSeen(_myUid);
  }

  void openChat(UserModel admin) {
    final cId = ChatModel.buildChatId(_myUid, admin.uid);
    Get.toNamed(AppRoutes.chatRoom, arguments: {
      'chatId': cId,
      'otherName': admin.displayName,
      'otherUid': admin.uid,
    });
  }
}
