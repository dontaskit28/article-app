import 'package:article_app/models/article_model.dart';
import 'package:get/get.dart';
import '../services/http_service.dart';

class ArticleController extends GetxController {
  var articles = <Article>[].obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var errorMessage = ''.obs; 
  Rx<Article?> selectedArticle = Rx<Article?>(null);

  int currentPage = 1;
  int lastPage = 1;
  int pageSize = 15;

  @override
  void onInit() {
    fetchArticles();
    super.onInit();
  }

  /// Fetch list of articles with pagination
  void fetchArticles({bool isRefresh = false, Map<String, dynamic>? filters}) async {
    if (isRefresh) {
      currentPage = 1;
      articles.clear();
    }

    if (currentPage > lastPage || isLoading.value) return;

    try {
      isLoading(true);
      errorMessage.value = '';

      var response = await HttpService.getArticles(
        page: currentPage,
        size: pageSize,
        filters: filters,
      );

      if (response["success"]) {
        lastPage = response["data"]["last_page"];
        var fetchedArticles = response["data"]["records"];
        
          currentPage++;
        
          for (var article in fetchedArticles) {
            articles.add(Article.fromJson(article));
          }
      } else {
        errorMessage.value = "Failed to fetch articles";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading(false);
    }
  }



  /// Fetch a single article by ID
  void fetchArticleById(String articleId) async {
    try {
      isLoading(true);
      errorMessage.value = '';

      var response = await HttpService.getArticleById(articleId);
      if (response["success"]) {
        selectedArticle.value = Article.fromJson( response["data"]);
      } else {
        errorMessage.value = "Failed to fetch article";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading(false);
    }
  }

  /// Create a new article
  Future<bool> createArticle(Map<String, dynamic> articleData) async {
    try {
      isUpdating(true);
      errorMessage.value = '';

      var response = await HttpService.createArticle(articleData);

      if (response["success"]) {
        articles.insert(0, Article.fromJson(response["data"])); // Add new article to the list
        return true;
      } else {
        errorMessage.value = "Failed to create article";
        return false;
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      return false;
    } finally {
      isUpdating(false);
    }
  }

  /// Update an existing article
  Future<bool> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    try {
      isUpdating(true);
      errorMessage.value = '';

      var response = await HttpService.updateArticle(articleId, updates);
      if (response["success"]) {
        int index = articles.indexWhere(
          (article) => article.id == articleId,
        );
        if (index != -1) {
          articles[index] = Article.fromJson(response["data"]);
        }
        if (selectedArticle.value != null) {
          selectedArticle.value = Article.fromJson(response["data"]);
        }
        return true;
      } else {
        errorMessage.value = "Failed to update article";
        return false;
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      return false;
    } finally {
      isUpdating(false);
    }
  }
}
