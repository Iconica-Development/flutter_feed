// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter_feed_firebase/src/config/firebase_feed_options.dart";
import "package:flutter_feed_firebase/src/models/firebase_user_document.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";

class FirebaseFeedUserService implements FeedUserService {
  FirebaseFeedUserService({
    FirebaseApp? app,
    FirebaseFeedOptions? options,
  }) {
    var appInstance = app ?? Firebase.app();
    _db = FirebaseFirestore.instanceFor(app: appInstance);
    _options = options ?? const FirebaseFeedOptions();
  }

  late FirebaseFirestore _db;
  late FirebaseFeedOptions _options;

  final Map<String, FeedPosterUserModel> _users = {};

  CollectionReference<FirebaseUserDocument> get _userCollection => _db
      .collection(_options.usersCollectionName)
      .withConverter<FirebaseUserDocument>(
        fromFirestore: (snapshot, _) => FirebaseUserDocument.fromJson(
          snapshot.data()!,
          snapshot.id,
        ),
        toFirestore: (user, _) => user.toJson(),
      );
  @override
  Future<FeedPosterUserModel?> getUser(String userId) async {
    if (_users.containsKey(userId)) {
      return _users[userId]!;
    }
    var data = (await _userCollection.doc(userId).get()).data();

    var user = data == null
        ? FeedPosterUserModel(userId: userId)
        : FeedPosterUserModel(
            userId: userId,
            firstName: data.firstName,
            lastName: data.lastName,
            imageUrl: data.imageUrl,
          );

    _users[userId] = user;

    return user;
  }
}
