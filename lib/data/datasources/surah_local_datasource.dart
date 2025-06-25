import 'package:alquran_app/data/datasources/database_helper.dart';
import 'package:alquran_app/data/models/surah_model.dart';
import 'package:sqflite/sql.dart';

class SurahLocalDatasource {
  final DatabaseHelper _databaseHelper;

  SurahLocalDatasource({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  // untuk menyimpan daftar surah ke sqflite
  Future<void> saveAllSurah(List<SurahModel> surahs) async {
    final db = await _databaseHelper.database;
    // menggunakan batching untuk efisiensi saat insert banyak data
    final batch = db.batch();
    for (var surah in surahs) {
      batch.insert(DatabaseHelper.tableSurah, surah.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<SurahModel>> getAllSurah() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.tableSurah);

    if (maps.isNotEmpty) {
      return maps.map((map) => SurahModel.fromMap(map)).toList();
    } else {
      return [];
    }
  }
}
