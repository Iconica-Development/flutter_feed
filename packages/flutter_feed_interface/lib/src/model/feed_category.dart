class FeedCategory {
  const FeedCategory({
    required this.title,
    this.id,
    this.description,
  });

  factory FeedCategory.fromJson(String id, Map<String, dynamic> json) =>
      FeedCategory(
        id: id,
        title: json["title"] as String,
        description: json["description"] as String?,
      );

  /// The unique identifier of this category.
  ///
  /// If this is null it means the category hasn't been saved yet and exists
  /// only in memory.
  final String? id;

  /// The title of this category.
  final String title;

  /// The description of this category.
  final String? description;

  FeedCategory copyWith({
    String? id,
    String? title,
    String? description,
  }) =>
      FeedCategory(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  Map<String, Object?> toJson() => {
        "title": title,
        "description": description,
      };
}
