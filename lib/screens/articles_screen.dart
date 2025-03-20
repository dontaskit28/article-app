import 'package:article_app/controllers/articles_controller.dart';
import 'package:article_app/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/article_card.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final ArticleController controller = Get.find<ArticleController>();
  final ScrollController _scrollController = ScrollController();

  String selectedCategory = "All";
  List<String> filtersList = ["All", "Technology", "Programming", "Flutter"];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
       controller.fetchArticles();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Articles", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),), centerTitle: true,),
      body: Column(
        children: [
          _buildFilterBar(), // Add the filter bar
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.articles.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }
              if (controller.articles.isEmpty) {
                return Center(child: Text("No articles found. Try changing filters!"));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: controller.articles.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.articles.length) {
                    return controller.isLoading.value
                        ? Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SizedBox();
                  }
                  var article = controller.articles[index];
                  return ArticleCard(article: article);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddArticleDialog(context),
        tooltip: "Add New Article",
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedCategory,
                items: filtersList
                .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                    _applyFilters();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    Map<String, dynamic> filters = {};
    if (selectedCategory != "All") {
      filters["category"] = {"values": [selectedCategory]};
    } else {
      filters.clear();
    }
    
    controller.fetchArticles(isRefresh: true, filters: filters);
  }

  /// Show a dialog to create a new article
  void showAddArticleDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController authorController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController readTimeController = TextEditingController();

    Get.defaultDialog(
      title: "Add New Article",
      contentPadding: EdgeInsets.all(16),
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
          TextField(
            controller: readTimeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Read Time (minutes)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel"),
        ),
        Obx(() => controller.isUpdating.value 
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () async {
                int readTime = int.tryParse(readTimeController.text.trim()) ?? 150;

                Map<String, dynamic> newArticle = {
                  "title": titleController.text.trim(),
                  "description": descriptionController.text.trim(),
                  "author": authorController.text.trim(),
                  "category": categoryController.text.trim(),
                  "read_time": readTime,
                };

                bool success = await controller.createArticle(newArticle);
                if (success) {
                  Get.back();
                  SnackMessage.showSnackBar(title: "Success", message: "Article added successfully");
                } else {
                  SnackMessage.showSnackBar(title: "Error", message: "Failed to add article",isError: true);
                }
              },
              child: Text("Add"),
            ),
        ),
      ],
    );
  }
}
