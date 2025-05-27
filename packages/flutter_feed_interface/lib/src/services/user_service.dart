// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter_feed_interface/flutter_feed_interface.dart";

mixin FeedUserService {
  Future<FeedPosterUserModel?> getUser(String userId);
}
