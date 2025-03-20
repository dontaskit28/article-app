import 'package:article_app/controllers/articles_controller.dart';
import 'package:article_app/models/article_model.dart';
import 'package:article_app/screens/article_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticleCard extends GetView<ArticleController> {
  final Article article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            controller.fetchArticleById(article.id!);
            Get.to(() => ArticleDetailScreen());
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Title (Larger Text, Single Line)
                Text(
                  article.title ?? "No Title",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20, // Larger text
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),

                // Article Subtitle (Author Name, Single Line)
                Text(
                  article.author ?? "Unknown Author",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16, // Bigger than default
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),

                // Read Time
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      "${article.readTime ?? 0} mins read",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}