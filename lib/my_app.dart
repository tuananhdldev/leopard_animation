import 'package:animal_animation_app/main_page.dart';
import 'package:animal_animation_app/styles.dart';
import 'package:animal_animation_app/test_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark, scaffoldBackgroundColor: mainBlack),
      home: TestPage(),
    );
  }
}
