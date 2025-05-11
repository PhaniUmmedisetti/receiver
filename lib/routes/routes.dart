import 'package:get/get.dart';
import '../screens/main_screen.dart';
import '../screens/file_details_screen.dart';

class AppRoutes {
  static const String main = '/main';
  static const String fileDetails = '/file_details';

  static List<GetPage> getPages = [
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: fileDetails, page: () => const FileDetailsScreen()),
  ];
}