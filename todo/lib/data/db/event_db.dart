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
        color INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE user_event_status (
        user_id TEXT,
        event_id INTEGER,
        is_favorite INTEGER DEFAULT 0,
        is_booked INTEGER DEFAULT 0,
        FOREIGN KEY (event_id) REFERENCES events(id)
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
      JOIN user_event_status s ON e.id = s.event_id
      WHERE s.user_id = ? AND s.is_favorite = 1
    ''',
      [userId],
    );

    return result.map((e) => EventData.fromMap(e)).toList();
  }

  Future<List<EventData>> getUserBookings(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT e.* FROM events e
      JOIN user_event_status s ON e.id = s.event_id
      WHERE s.user_id = ? AND s.is_booked = 1
    ''',
      [userId],
    );

    return result.map((e) => EventData.fromMap(e)).toList();
  }

  Future<void> deleteEvent(int eventId) async {
    final db = await database;

    // Delete related status records first
    await db.delete(
      'user_event_status',
      where: 'event_id = ?',
      whereArgs: [eventId],
    );

    // Then delete the event
    await db.delete('events', where: 'id = ?', whereArgs: [eventId]);
  }

  Future<void> updateEventStatus({
    required String userId,
    required int eventId,
    bool? isFavorite,
    bool? isBooked,
  }) async {
    final db = await database;

    // Get current values if exists
    final result = await db.query(
      'user_event_status',
      where: 'user_id = ? AND event_id = ?',
      whereArgs: [userId, eventId],
    );

    int currentFavorite = 0;
    int currentBooked = 0;

    if (result.isNotEmpty) {
      currentFavorite = result.first['is_favorite'] as int;
      currentBooked = result.first['is_booked'] as int;
    }

    await db.insert('user_event_status', {
      'user_id': userId,
      'event_id': eventId,
      'is_favorite':
          isFavorite != null ? (isFavorite ? 1 : 0) : currentFavorite,
      'is_booked': isBooked != null ? (isBooked ? 1 : 0) : currentBooked,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
