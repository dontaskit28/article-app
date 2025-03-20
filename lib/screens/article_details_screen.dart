import 'package:article_app/controllers/articles_controller.dart';
import 'package:article_app/models/article_model.dart';
import 'package:article_app/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleDetailScreen extends GetView<ArticleController> {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Article Details")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        Article? article = controller.selectedArticle.value;
        if (article == null) {
          return Center(child: Text("No article found"));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title ?? "No Title",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "By ${article.author ?? "Unknown"}",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 8),
              Text(
                "Category: ${article.category ?? "N/A"}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Text(
                article.description ?? "No Description",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),
              Row(
                  children: [
                    Icon(Icons.access_time, size: 16,),
                    SizedBox(width: 6),
                    Text(
                      "${article.readTime ?? 0} mins read",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => showUpdateDialog(context, article),
                  icon: Icon(Icons.edit, size: 18, color: Colors.white,),
                  label: Text("Edit Article", style: TextStyle(fontSize: 16,color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 16,color: Colors.white),
                    backgroundColor: const Color.fromARGB(255, 161, 127, 167),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  
  void showUpdateDialog(BuildContext context, Article article) {
    TextEditingController titleController = TextEditingController(text: article.title);
    TextEditingController descriptionController = TextEditingController(text: article.description);
    TextEditingController authorController = TextEditingController(text: article.author);
    TextEditingController categoryController = TextEditingController(text: article.category);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Update Article", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              _buildTextField(controller: titleController, label: "Title"),
              _buildTextField(controller: descriptionController, label: "Description"),
              _buildTextField(controller: authorController, label: "Author"),
              _buildTextField(controller: categoryController, label: "Category"),
              SizedBox(height: 20),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                  controller.isUpdating.value ? CircularProgressIndicator() : 
                    ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> updatedData = {
                          "title": titleController.text.trim(),
                          "description": descriptionController.text.trim(),
                          "author": authorController.text.trim(),
                          "category": categoryController.text.trim(),
                        };

                        bool success = await controller.updateArticle(article.id!, updatedData);
                        if (success) {
                          Get.back();
                          SnackMessage.showSnackBar(title: "Success", message: "Article updated successfully");
                        } else {
                          SnackMessage.showSnackBar(title: "Error", message: "Failed to update article",isError: true,);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text("Update"),
                    ),
                    ],
                  ));
                }),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// Custom styled TextField widget
  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
