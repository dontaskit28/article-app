import 'package:article_app/controllers/articles_controller.dart';
import 'package:get/get.dart';

class ArticleBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ArticleController>(ArticleController());
  }
}
