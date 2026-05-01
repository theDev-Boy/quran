import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'wuran_majeed.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE verses (
          id INTEGER PRIMARY KEY,
          surah_id INTEGER NOT NULL,
          ayah_number INTEGER NOT NULL,
          page_number INTEGER NOT NULL,
          parah_number INTEGER NOT NULL,
          arabic_text TEXT NOT NULL,
          line_number_on_page INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE surahs (
          id INTEGER PRIMARY KEY,
          name_arabic TEXT NOT NULL,
          name_english TEXT NOT NULL,
          name_urdu TEXT NOT NULL,
          name_hindi TEXT NOT NULL,
          name_pashto TEXT NOT NULL,
          revelation_place TEXT NOT NULL,
          total_verses INTEGER NOT NULL,
          start_page INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE parahs (
          id INTEGER PRIMARY KEY,
          name_arabic TEXT NOT NULL,
          start_page INTEGER NOT NULL,
          end_page INTEGER NOT NULL,
          total_pages INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE translations (
          id INTEGER PRIMARY KEY,
          verse_id INTEGER NOT NULL,
          language TEXT NOT NULL,
          text TEXT NOT NULL,
          FOREIGN KEY (verse_id) REFERENCES verses(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE audio_files (
          id INTEGER PRIMARY KEY,
          verse_id INTEGER NOT NULL,
          qari_id INTEGER NOT NULL,
          file_path TEXT NOT NULL,
          duration_ms INTEGER NOT NULL,
          FOREIGN KEY (verse_id) REFERENCES verses(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE translation_audio_files (
          id INTEGER PRIMARY KEY,
          verse_id INTEGER NOT NULL,
          language TEXT NOT NULL,
          voice_id INTEGER NOT NULL,
          file_path TEXT NOT NULL,
          duration_ms INTEGER NOT NULL,
          is_natural_human BOOLEAN NOT NULL DEFAULT 1,
          FOREIGN KEY (verse_id) REFERENCES verses(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
      )
    ''');
    
    // Add more tables as per PRD...
  }
}
