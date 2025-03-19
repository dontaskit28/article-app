import 'package:article_app/controllers/articles_controller.dart';
import 'package:article_app/screens/article_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleListScreen extends GetView<ArticleController> {
  const ArticleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Articles")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.articles.isEmpty) {
          return Center(child: Text("No articles found. Add a new one!"));
        }
        return ListView.builder(
          itemCount: controller.articles.length,
          itemBuilder: (context, index) {
            var article = controller.articles[index];
            return ListTile(
              title: Text(article["title"]),
              subtitle: Text(article["author"]),
              onTap:
                  () => Get.to(
                    () => ArticleDetailScreen(articleId: article["id"]),
                  ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddArticleDialog(context),
        tooltip: "Add New Article",
        child: Icon(Icons.add),
      ),
    );
  }

  /// Show a dialog to create a new article
  void showAddArticleDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController categoryController = TextEditingController();

    Get.defaultDialog(
      title: "Add New Article",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          TextField(
            controller: authorController,
            decoration: InputDecoration(labelText: "Author"),
          ),
          TextField(
            controller: categoryController,
            decoration: InputDecoration(labelText: "Category"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> newArticle = {
              "title": titleController.text.trim(),
              "description": descriptionController.text.trim(),
              "author": authorController.text.trim(),
              "category": categoryController.text.trim(),
              "read_time": 150, // Default read time
            };

            bool success = await controller.createArticle(newArticle);
            if (success) {
              Get.back(); // Close the dialog
              Get.snackbar(
                "Success",
                "Article added successfully",
                snackPosition: SnackPosition.BOTTOM,
              );
            } else {
              Get.snackbar(
                "Error",
                "Failed to add article",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
