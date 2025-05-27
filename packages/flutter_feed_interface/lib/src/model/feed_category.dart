import "package:flutter/material.dart";

@immutable
class FeedCategory {
  const FeedCategory({
    required this.key,
    required this.title,
    this.icon,
    this.canCreate = true,
    this.canView = true,
  });

  FeedCategory.fromJson(Map<String, dynamic> json)
      : key = json["key"] as String?,
        title = json["title"] as String,
        icon = json["icon"] as Widget?,
        canCreate = json["canCreate"] as bool? ?? true,
        canView = json["canView"] as bool? ?? true;

  final String? key;
  final String title;
  final Widget? icon;
  final bool canCreate;
  final bool canView;

  FeedCategory copyWith({
    String? key,
    String? title,
    Widget? icon,
    bool? canCreate,
    bool? canView,
  }) =>
      FeedCategory(
        key: key ?? this.key,
        title: title ?? this.title,
        icon: icon ?? this.icon,
        canCreate: canCreate ?? this.canCreate,
        canView: canView ?? this.canView,
      );

  Map<String, Object?> toJson() => {
        "key": key,
        "title": title,
        "icon": icon,
        "canCreate": canCreate,
        "canView": canView,
      };
}
