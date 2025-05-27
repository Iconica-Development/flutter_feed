// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:math";

import "package:flutter_feed_timeline/src/models/timeline_item.dart";
import "package:flutter_feed_timeline/src/repositories/feed_services.dart";

class _MemoryStorageSingleton {
  List<TimelineItem> items = const [];

  static List<TimelineItem> _getMockedPosts() => [
        TimelineItem(
          id: "Post0",
          title: "De topper van de maand september",
          description:
              "Dit is onze topper van de maand september! Gefeliciteerd!",
          media: [
            "https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_1.png?alt=media&token=e4b2f9f3-c81f-4ac7-a938-e846691399f7",
          ],
          createdAt: DateTime.now(),
          authorName: "Robin de Vries",
          likeCount: 72,
          likedByUser: false,
        ),
        TimelineItem(
          id: "Post1",
          title: "De soep van de week is: Aspergesoep",
          description:
              "Aspergesoep is echt een heerlijke delicatesse. Deze soep wordt"
              " vaak gemaakt met verse asperges, bouillon en wat kruiden voor"
              " smaak. Het is een perfecte keuze voor een lichte en smaakvolle"
              " maaltijd, vooral in het voorjaar wanneer asperges in seizoen"
              " zijn. We serveren het met een vleugje room en wat knapperige"
              " croutons voor die extra touch.",
          media: [
            "https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_2.png?alt=media&token=ee4a8771-531f-4d1d-8613-a2366771e775",
          ],
          createdAt: DateTime.now(),
          authorName: "Elise Welling",
          likeCount: 64,
          likedByUser: false,
        ),
      ];

  static _MemoryStorageSingleton? _storage;

  // ignore: prefer_constructors_over_static_methods
  static _MemoryStorageSingleton get instance {
    if (_storage == null) {
      _storage = _MemoryStorageSingleton();
      _storage!.items = _getMockedPosts();
    }

    return _storage!;
  }
}

class MemoryFeedItemService implements TimelineRepository {
  MemoryFeedItemService();

  @override
  Future<List<TimelineItem>> getItems({int? limit, int offset = 0}) async {
    var items = _MemoryStorageSingleton.instance.items;
    items.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return a.createdAt!.compareTo(b.createdAt!);
      }

      return a.id.compareTo(b.id);
    });

    return items.sublist(offset, limit ?? items.length);
  }

  @override
  Future<TimelineItem> createItem(TimelineItem item) async {
    var storage = _MemoryStorageSingleton.instance;

    var id = Random().nextInt(1000).toString();
    var updatedItem = item.copyWith(id: id);
    storage.items.add(updatedItem);

    return updatedItem;
  }

  @override
  Future<void> deleteItem(TimelineItem item) async {
    var storage = _MemoryStorageSingleton.instance;
    storage.items.remove(item);
  }
}

class MemoryTimelineLikesRepository implements TimelineLikesRepository {
  @override
  Future<void> likeItem(TimelineItem item) async {
    var storage = _MemoryStorageSingleton.instance;

    storage.items.remove(item);

    if (item.likedByUser) {
      storage.items.add(
        item.copyWith(
          likeCount: item.likeCount - 1,
          likedByUser: false,
        ),
      );
    } else {
      storage.items.add(
        item.copyWith(
          likeCount: item.likeCount + 1,
          likedByUser: true,
        ),
      );
    }
  }
}
