import 'package:get/get.dart';
import '../services/http_service.dart';

class ArticleController extends GetxController {
  var articles = [].obs; // List of articles
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs; // Error message
  var selectedArticle = {}.obs; // Stores selected article

  int currentPage = 1;
  int lastPage = 1;
  int pageSize = 10;

  @override
  void onInit() {
    fetchArticles();
    super.onInit();
  }

  /// Fetch list of articles with pagination
  void fetchArticles({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      articles.clear();
    }

    if (currentPage > lastPage) return;

    try {
      isLoading(true);
      errorMessage.value = '';

      var response = await HttpService.getArticles(
        page: currentPage,
        size: pageSize,
      );

      if (response["success"]) {
        lastPage = response["data"]["last_page"];
        var fetchedArticles = response["data"]["records"];
        articles.addAll(fetchedArticles);
        currentPage++;
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
        selectedArticle.value = response["data"];
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
      isLoading(true);
      errorMessage.value = '';

      var response = await HttpService.createArticle(articleData);

      if (response["success"]) {
        articles.insert(0, response["data"]); // Add new article to the list
        return true;
      } else {
        errorMessage.value = "Failed to create article";
        return false;
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
      return false;
    } finally {
      isLoading(false);
    }
  }

  /// Update an existing article
  Future<bool> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    try {
      isLoading(true);
      errorMessage.value = '';

      var response = await HttpService.updateArticle(articleId, updates);

      if (response["success"]) {
        int index = articles.indexWhere(
          (article) => article["id"] == articleId,
        );
        if (index != -1) {
          articles[index] = response["data"];
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
      isLoading(false);
    }
  }
}
