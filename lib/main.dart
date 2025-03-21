import 'package:article_app/bindings/article_binding.dart';
import 'package:article_app/screens/articles_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ArticleListScreen(),
      initialBinding: ArticleBindings(),
    );
  }
}



