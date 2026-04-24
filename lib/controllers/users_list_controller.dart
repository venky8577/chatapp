import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../services/database_service.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class UsersListController extends GetxController {
  final DatabaseService _db = DatabaseService();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;

  // AuthController currentUser ని prefer చేయి; లేకపోతే FirebaseAuth uid వాడు
  String get _myUid =>
      Get.find<AuthController>().currentUser.value?.uid ??
      FirebaseAuth.instance.currentUser?.uid ??
      '';

  List<UserModel> get filteredUsers {
    if (searchQuery.value.isEmpty) return users;
    return users
        .where((u) =>
            u.displayName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            u.email.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    final uid = _myUid;
    if (uid.isEmpty) return;
    _db.allUsers(uid).listen((list) => users.value = list);
    _db.updateLastSeen(uid);
  }

  void openChat(UserModel otherUser) {
    final cId = ChatModel.buildChatId(_myUid, otherUser.uid);
    Get.toNamed(AppRoutes.chatRoom, arguments: {
      'chatId': cId,
      'otherName': otherUser.displayName,
      'otherUid': otherUser.uid,
    });
  }

  void onSearch(String query) => searchQuery.value = query;
}
