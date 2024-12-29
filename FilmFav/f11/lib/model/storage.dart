import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class StorageShared {
  static Future<List<String>> getData() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    List<String> data = [''];
    data = p.getStringList("Mark") ?? [];
    return data;
  }

  static Future<void> storeData(List<String> item) async {
    // SharedPreferences.setMockInitialValues({});
    EasyLoading.show(status: "loading ...");
    SharedPreferences p = await SharedPreferences.getInstance();
    List<String> oldData = await getData();
    oldData.addAll(item);
    await p.setStringList("Mark", oldData);
    EasyLoading.showSuccess("Saved");
  }

  static Future<void> clearData() async {
    EasyLoading.show(status: "loading ...");
    SharedPreferences p = await SharedPreferences.getInstance();
    await p.clear();
    EasyLoading.showSuccess("Cleared");
  }
}
