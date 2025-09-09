import 'package:todo/data/db/event_db.dart';
import 'package:todo/data/model/eventdata_model.dart';

class EventRepository {
  final EventDatabase _db;

  EventRepository(this._db);

  Future<List<EventData>> getAllEvents() {
    return _db.getAllEvents();
  }

  Future<List<EventData>> getUserFavorites(String userId) {
    return _db.getUserFavorites(userId);
  }

  Future<List<EventData>> getUserBookings(String userId) {
    return _db.getUserBookings(userId);
  }

  Future<void> insertEvent(EventData event) {
    return _db.insertEvent(event);
  }

  Future<void> updateEventStatus({
    required String userId,
    required int eventId,
    bool? isFavorite,
    bool? isBooked,
  }) {
    return _db.updateEventStatus(
      userId: userId,
      eventId: eventId,
      isFavorite: isFavorite,
      isBooked: isBooked,
    );
  }
}
