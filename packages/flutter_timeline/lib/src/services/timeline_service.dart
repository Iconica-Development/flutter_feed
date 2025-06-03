import "package:flutter_timeline_interface/flutter_timeline_interface.dart";

class TimelineService {
  const TimelineService({
    required TimelineRepository repository,
    required TimelineLikesRepository likesRepository,
  })  : _repository = repository,
        _likesRepository = likesRepository;

  final TimelineRepository _repository;
  final TimelineLikesRepository _likesRepository;

  Future<List<TimelineItem>> getItems({int? limit, int offset = 0}) async =>
      _repository.getItems(limit: limit, offset: offset);

  Future<TimelineItem> createItem(TimelineItem item) async =>
      _repository.createItem(item);

  Future<void> deleteItem(TimelineItem item) async =>
      _repository.deleteItem(item);

  Future<void> likeItem(TimelineItem item) async =>
      _likesRepository.likeItem(item);
}
