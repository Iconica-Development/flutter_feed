// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class TimelineItem {
  const TimelineItem({
    required this.id,
    required this.title,
    this.description,
    this.media = const [],
    this.authorName,
    this.authorAvatarUrl,
    this.createdAt,
    this.likeCount = 0,
    this.likedByUser = false,
  });

  final String id;
  final String title;
  final String? description;
  final List<String> media;
  final String? authorName;
  final String? authorAvatarUrl;
  final DateTime? createdAt;
  final int likeCount;
  final bool likedByUser;

  TimelineItem copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? media,
    String? authorName,
    String? authorAvatarUrl,
    DateTime? createdAt,
    int? likeCount,
    bool? likedByUser,
  }) =>
      TimelineItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        media: media ?? this.media,
        authorName: authorName ?? this.authorName,
        authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
        createdAt: createdAt ?? this.createdAt,
        likeCount: likeCount ?? this.likeCount,
        likedByUser: likedByUser ?? this.likedByUser,
      );

  @override
  bool operator ==(Object other) {
    if (other is! TimelineItem) return false;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
