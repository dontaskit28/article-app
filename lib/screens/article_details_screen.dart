import 'package:article_app/controllers/articles_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleDetailScreen extends GetView<ArticleController> {
  final String articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    // Fetch article details when the screen loads
    controller.fetchArticleById(articleId);

    return Scaffold(
      appBar: AppBar(title: Text("Article Details")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        var article = controller.selectedArticle;
        if (article.isEmpty) {
          return Center(child: Text("No article found"));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article["title"] ?? "No Title",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "By ${article["author"] ?? "Unknown"}",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 8),
              Text(
                "Category: ${article["category"] ?? "N/A"}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                article["description"] ?? "No Description",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    () => showUpdateDialog(
                      context,
                      article as Map<String, dynamic>,
                    ),
                child: Text("Edit Article"),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Show a dialog to update the article
  void showUpdateDialog(BuildContext context, Map<String, dynamic> article) {
    TextEditingController titleController = TextEditingController(
      text: article["title"],
    );
    TextEditingController descriptionController = TextEditingController(
      text: article["description"],
    );

    Get.defaultDialog(
      title: "Update Article",
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
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            Map<String, dynamic> updatedData = {
              "title": titleController.text.trim(),
              "description": descriptionController.text.trim(),
            };

            bool success = await controller.updateArticle(
              articleId,
              updatedData,
            );
            if (success) {
              Get.back(); // Close the dialog
              Get.snackbar(
                "Success",
                "Article updated successfully",
                snackPosition: SnackPosition.BOTTOM,
              );
            } else {
              Get.snackbar(
                "Error",
                "Failed to update article",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}
