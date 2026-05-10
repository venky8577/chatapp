import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../services/database_service.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';

class AdminHomeController extends GetxController {
  final DatabaseService _db = DatabaseService();

  final RxList<UserModel> students = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;

  String get _myUid =>
      Get.find<AuthController>().currentUser.value?.uid ??
      FirebaseAuth.instance.currentUser?.uid ??
      '';

  List<UserModel> get filteredStudents {
    if (searchQuery.value.isEmpty) return students;
    final q = searchQuery.value.toLowerCase();
    return students
        .where((s) =>
            s.displayName.toLowerCase().contains(q) || s.phone.contains(q))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    final uid = _myUid;
    if (uid.isEmpty) return;
    _db.allStudents(uid).listen((list) => students.value = list);
    _db.updateLastSeen(uid);
  }

  void openChat(UserModel student) {
    final cId = ChatModel.buildChatId(_myUid, student.uid);
    Get.toNamed(AppRoutes.chatRoom, arguments: {
      'chatId': cId,
      'otherName': student.displayName,
      'otherUid': student.uid,
    });
  }

  void onSearch(String query) => searchQuery.value = query;
}
