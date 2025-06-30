import 'package:alquran_app/data/datasources/surah_remote_datasource.dart';
import 'package:alquran_app/data/datasources/surah_local_datasource.dart';
import 'package:alquran_app/data/models/surah_model.dart';
import 'package:dartz/dartz.dart';

import '../models/surah_detail_model.dart';

class QuranRepository {
  final SurahRemoteDatasource remoteDataSource;
  final SurahLocalDatasource localDataSource;

  QuranRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<Either<String, List<SurahModel>>> getAllSurah() async {
    // 1. Coba ambil dari cache lokal dulu
    final localSurahs = await localDataSource.getAllSurah();
    if (localSurahs.isNotEmpty) {
      print("Data Surah diambil dari CACHE/SQFLITE");
      // Jika berhasil dari cache, langsung kembalikan sebagai 'Right'
      return Right(localSurahs);
    }

    // 2. Jika cache kosong, panggil remote data source
    print("Cache kosong, mengambil data dari API...");
    final remoteResult = await remoteDataSource.getAllSurah();

    // 3. Gunakan .fold untuk menangani hasil Either dari remoteDataSource
    return remoteResult.fold(
      (failureMessage) {
        // Jika dari API gagal (Left), teruskan pesan error-nya
        print("Gagal mengambil dari API: $failureMessage");
        return Left(failureMessage);
      },
      (surahList) async {
        // Jika dari API berhasil (Right), lakukan caching
        print("Berhasil mengambil dari API, menyimpan ke cache...");
        await localDataSource.saveAllSurah(surahList);
        // Kemudian kembalikan datanya
        return Right(surahList);
      },
    );
  }

  Future<Either<String, SurahDetailModel>> getDetailSurah(
      int surahNumber) async {
    // 1. Coba ambil dari cache lokal dulu
    try {
      final cachedSurahDetail =
          await localDataSource.getDetailSurahFromCache(surahNumber);
      if (cachedSurahDetail != null) {
        print("Detail Surah #$surahNumber diambil dari CACHE");
        return Right(cachedSurahDetail);
      }
    } catch (e) {
      print("Gagal mengambil detail dari cache: $e");
      // Jangan hentikan proses, lanjutkan untuk fetch dari API
    }

    // 2. Jika cache kosong atau error, panggil remote data source
    print("Cache detail surah #$surahNumber kosong, mengambil dari API...");
    final remoteResult = await remoteDataSource.getDetailSurah(surahNumber);

    // 3. Gunakan .fold untuk menangani hasil Either
    return remoteResult.fold(
      (failureMessage) {
        // Jika dari API gagal, teruskan pesan error-nya
        return Left(failureMessage);
      },
      (surahDetail) async {
        // Jika dari API berhasil, lakukan caching
        print("Berhasil mengambil detail dari API, menyimpan ke cache...");
        await localDataSource.cacheDetailSurah(surahDetail);
        // Kemudian kembalikan datanya
        return Right(surahDetail);
      },
    );
  }
}
