import 'package:get/get.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:alaram_app/routes/pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:alaram_app/views/main_page/main_page.dart';
import 'package:alaram_app/repository/countdown_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Alarm.init();
  await CountdownRepository.initRepo();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Alarm Application',
      getPages: Routes().getGetXPages(),
      initialRoute: kMainRoute,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
