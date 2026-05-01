import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecitationService {
  final AudioPlayer _player = AudioPlayer();
  late Database _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'timestamps.db');
    
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE verse_timestamps (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              qari_id INTEGER NOT NULL,
              surah_id INTEGER NOT NULL,
              ayah_number INTEGER NOT NULL,
              start_ms INTEGER NOT NULL,
              end_ms INTEGER NOT NULL,
              UNIQUE(qari_id, surah_id, ayah_number)
          )
        ''');
      },
    );
  }

  Future<void> playVerse(int surahId, int ayahNumber, int qariId) async {
    final result = await _db.query(
      'verse_timestamps',
      where: 'qari_id = ? AND surah_id = ? AND ayah_number = ?',
      whereArgs: [qariId, surahId, ayahNumber],
    );

    if (result.isEmpty) return;

    final startMs = result.first['start_ms'] as int;
    final endMs = result.first['end_ms'] as int;
    final duration = endMs - startMs;

    final surahPath = 'assets/recitation/qari_$qariId/surah_${surahId.toString().padLeft(3, '0')}.mp3';
    
    await _player.setAsset(surahPath);
    await _player.seek(Duration(milliseconds: startMs));
    _player.play();

    // Auto-stop at verse end
    Future.delayed(Duration(milliseconds: duration), () {
      if (_player.playing) {
        _player.pause();
      }
    });
  }

  Stream<ProcessingState> get onVerseComplete => _player.processingStateStream;
  
  void stop() => _player.stop();
  void dispose() => _player.dispose();
}
