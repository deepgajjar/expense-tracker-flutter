import 'package:flutter/material.dart';
import '../../data/colors.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final Rx<Color> _color = blackClr.obs;
  final _box = GetStorage();
  String key = 'isLightMode';

  Color get color => _color.value;

  @override
  void onInit() {
    super.onInit();
    // _color.value = _loadThemeFromBox ? Colors.white : Colors.black;
  }
  ThemeMode get theme =>  ThemeMode.light;
  // ThemeMode get theme => _loadThemeFromBox ? ThemeMode.dark : ThemeMode.light;
  // bool get _loadThemeFromBox => _box.read(_key) ?? false;
  // bool get _loadThemeFromBox => false;

  switchTheme(String mode) async {
    if(mode == 'isDarkMode'){
      Get.changeThemeMode(ThemeMode.dark);
      key = 'isDarkMode';
    }else{
      Get.changeThemeMode(ThemeMode.light);
      key = 'isLightMode';
    }

    print('theme _key ');
    print(key);

    _color.value = mode == 'isDarkMode' ? Colors.white : blackClr;
    update();
    // await _box.write(_key.toString(), !_loadThemeFromBox);
    // update();
  }
}
