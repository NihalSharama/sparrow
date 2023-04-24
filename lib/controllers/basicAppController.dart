import 'package:audioplayers/audioplayers.dart';
import 'package:get/state_manager.dart';

class BasicAppController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
