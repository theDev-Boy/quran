import 'package:sqflite/sqflite.dart';

void main() async {
  final dbPath = 'assets/db/timestamps.db';
  final db = await openDatabase(
    dbPath,
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

  print('📦 Populating sample timestamps for Al-Fatihah...');
  
  // Sample timestamps (Mishary Rashid Alafasy Surah 1)
  final samples = [
    {'qari': 1, 'surah': 1, 'ayah': 1, 'start': 0, 'end': 6000},
    {'qari': 1, 'surah': 1, 'ayah': 2, 'start': 6000, 'end': 11000},
    {'qari': 1, 'surah': 1, 'ayah': 3, 'start': 11000, 'end': 15000},
  ];

  for (var sample in samples) {
    await db.insert('verse_timestamps', {
      'qari_id': sample['qari'],
      'surah_id': sample['surah'],
      'ayah_number': sample['ayah'],
      'start_ms': sample['start'],
      'end_ms': sample['end'],
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  print('✅ Sample timestamps populated!');
  await db.close();
}
