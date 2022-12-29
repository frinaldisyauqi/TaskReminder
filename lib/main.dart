import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';

import 'services/notification_services.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/notification_screen.dart';

void main() async {
  // Must Write this Line When Convert main to async
  WidgetsFlutterBinding.ensureInitialized();
  NotifyHelper().initializeNotification();
  await GetStorage.init();
  await DBHelper.initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
    );
  }
}
