import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/data/model/eventdata_model.dart';

class EventDatabase {
  static final EventDatabase _instance = EventDatabase._internal();
  factory EventDatabase() => _instance;

  static Database? _db;

  EventDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'event_app.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        start TEXT,
        end TEXT,
        color INTEGER,
        favoriteFlag INTEGER DEFAULT 0,
        bookFlag INTEGER DEFAULT 0,
        favoriteCount INTEGER DEFAULT 0,
        bookCount INTEGER DEFAULT 0
      );
    ''');

    // await db.execute('''
    //   CREATE TABLE user_event_status (
    //     user_id TEXT,
    //     event_id INTEGER,
    //     is_favorite INTEGER DEFAULT 0,
    //     is_booked INTEGER DEFAULT 0,
    //     FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
    //   );
    // ''');
    await db.execute('''
    CREATE TABLE user_favorite_events (
      user_id TEXT,
      event_id INTEGER,
      FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
    );
  ''');

    await db.execute('''
    CREATE TABLE user_booked_events (
      user_id TEXT,
      event_id INTEGER,
      FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
    );
  ''');
  }

  Future<void> insertEvent(EventData event) async {
    final db = await database;
    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EventData>> getAllEvents() async {
    final db = await database;
    final maps = await db.query('events');
    return maps.map((e) => EventData.fromMap(e)).toList();
  }

  Future<List<EventData>> getUserFavorites(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT e.* FROM events e
      JOIN user_favorite_events s ON e.id = s.event_id
      WHERE s.user_id = ?
    ''',
      [userId],
    );
    print('updated: $result');
    return result.map((e) => EventData.fromMap(e)).toList();
  }

  Future<List<EventData>> getUserBookings(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT e.* FROM events e
      JOIN user_booked_events s ON e.id = s.event_id
      WHERE s.user_id = ?
    ''',
      [userId],
    );

    return result.map((e) => EventData.fromMap(e)).toList();
  }

  Future<void> deleteEvent(int eventId) async {
    final db = await database;

    await db.delete('events', where: 'id = ?', whereArgs: [eventId]);
  }

  Future<void> updateEventStatus({
    required String userId,
    required int eventId,
    bool? isFavorite,
    bool? isBooked,
  }) async {
    final db = await database;

    // Handle favorite status
    if (isFavorite != null) {
      if (isFavorite) {
        await db.insert('user_favorite_events', {
          'user_id': userId,
          'event_id': eventId,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        await db.delete(
          'user_favorite_events',
          where: 'user_id = ? AND event_id = ?',
          whereArgs: [userId, eventId],
        );
      }
    }

    // Handle booked status
    if (isBooked != null) {
      if (isBooked) {
        await db.insert('user_booked_events', {
          'user_id': userId,
          'event_id': eventId,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      } else {
        await db.delete(
          'user_booked_events',
          where: 'user_id = ? AND event_id = ?',
          whereArgs: [userId, eventId],
        );
      }
    }
  }

  // Future<void> updateEventStatus({
  //   required String userId,
  //   required int eventId,
  //   bool? isFavorite,
  //   bool? isBooked,
  // }) async {
  //   final db = await database;

  //   // Get current values if exists
  //   final result = await db.query(
  //     'user_event_status',
  //     where: 'user_id = ? AND event_id = ?',
  //     whereArgs: [userId, eventId],
  //   );

  //   int currentFavorite = 0;
  //   int currentBooked = 0;

  //   if (result.isNotEmpty) {
  //     currentFavorite = result.first['is_favorite'] as int;
  //     currentBooked = result.first['is_booked'] as int;
  //   }

  //   await db.insert('user_event_status', {
  //     'user_id': userId,
  //     'event_id': eventId,
  //     'is_favorite':
  //         isFavorite != null ? (isFavorite ? 1 : 0) : currentFavorite,
  //     'is_booked': isBooked != null ? (isBooked ? 1 : 0) : currentBooked,
  //   }, conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  Future<void> editEvent(EventData event) async {
    final db = await database;
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<EventData> getEventById(int eventId) async {
    final db = await database;
    final maps = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [eventId],
    );
    return EventData.fromMap(maps.first);
  }

  Future<dynamic> getuserwitheventdata(String userId, String eventid) async {
    final db = await database;
    final result = await db.query(
      'user_event_status',
      where: 'user_id = ? AND event_id = ?',
      whereArgs: [userId, eventid],
    );
    print(result.first);
    return result.first;
  }
}
