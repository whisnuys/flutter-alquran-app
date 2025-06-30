import 'package:alquran_app/data/datasources/database_helper.dart';
import 'package:alquran_app/data/models/surah_model.dart';
import 'package:sqflite/sql.dart';

import '../models/surah_detail_model.dart';

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

  Future<void> cacheDetailSurah(SurahDetailModel surah) async {
    final db = await _databaseHelper.database;

    // Gunakan batch untuk memastikan semua operasi berhasil atau tidak sama sekali (transaksi)
    final batch = db.batch();

    // 1. Simpan/Update data utama surah (deskripsi, dll)
    final surahDataForDb = {
      'nomor': surah.nomor,
      'nama': surah.nama,
      'namaLatin': surah.namaLatin,
      'jumlahAyat': surah.jumlahAyat,
      'tempatTurun': surah.tempatTurun,
      'arti': surah.arti,
      'deskripsi': surah.deskripsi,
      'audio': surah.audioFull['05'] ?? '',
    };
    batch.insert(
      DatabaseHelper.tableSurah,
      surahDataForDb,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 2. Hapus ayat lama (jika ada) untuk surah ini, untuk menghindari duplikasi
    batch.delete(
      DatabaseHelper.tableAyat,
      where: '${DatabaseHelper.columnAyatSurahNomor} = ?',
      whereArgs: [surah.nomor],
    );

    // 3. Masukkan semua ayat baru ke dalam tabel ayat
    for (final ayat in surah.ayat) {
      batch.insert(
        DatabaseHelper.tableAyat,
        ayat.toDbMap(surah.nomor),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
    print('Berhasil cache detail untuk Surah ${surah.namaLatin}');
  }

// Metode BARU untuk mengambil detail surah dari cache
  Future<SurahDetailModel?> getDetailSurahFromCache(int surahNumber) async {
    final db = await _databaseHelper.database;

    // 1. Ambil data utama surah dari tabel 'surah'
    final surahResults = await db.query(
      DatabaseHelper.tableSurah,
      where: '${DatabaseHelper.columnNomor} = ?',
      whereArgs: [surahNumber],
    );

    if (surahResults.isNotEmpty) {
      // 2. Jika surah ditemukan, ambil semua ayat yang terkait dari tabel 'ayat'
      final ayatResults = await db.query(
        DatabaseHelper.tableAyat,
        where: '${DatabaseHelper.columnAyatSurahNomor} = ?',
        whereArgs: [surahNumber],
        orderBy: DatabaseHelper
            .columnAyatNomorAyat, // Urutkan berdasarkan nomor ayat
      );

      // 3. Gabungkan hasilnya menjadi satu objek SurahDetailModel
      final surahData = surahResults.first;
      final List<AyatModel> ayatList =
          ayatResults.map((map) => AyatModel.fromDbMap(map)).toList();

      // Jika tidak ada ayat di cache tapi surahnya ada, kembalikan null agar fetch dari API
      if (ayatList.isEmpty) return null;

      return SurahDetailModel(
        nomor: surahData['nomor'] as int,
        nama: surahData['nama'] as String,
        namaLatin: surahData['namaLatin'] as String,
        jumlahAyat: surahData['jumlahAyat'] as int,
        tempatTurun: surahData['tempatTurun'] as String,
        arti: surahData['arti'] as String,
        deskripsi: surahData['deskripsi'] as String,
        audioFull: {'05': surahData['audio'] as String},
        ayat: ayatList,
        suratSebelumnya: surahData['suratSebelumnya'] as bool? ?? false,
      );
    }

    return null;
  }
}
