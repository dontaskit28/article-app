class Article {
  String? id;
  String? title;
  String? author;
  String? category;
  String? description;
  int? readTime;
  String? createdAt;
  String? updatedAt;

  Article({
    this.id,
    this.title,
    this.author,
    this.category,
    this.description,
    this.readTime,
    this.createdAt,
    this.updatedAt,
  });

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    category = json['category'];
    description = json['description'];
    readTime = json['read_time'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['author'] = author;
    data['category'] = category;
    data['description'] = description;
    data['read_time'] = readTime;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
