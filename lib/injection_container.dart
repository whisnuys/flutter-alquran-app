import 'package:alquran_app/cubit/surah/surah_cubit.dart';
import 'package:alquran_app/data/datasources/surah_remote_datasource.dart';
import 'package:alquran_app/data/datasources/surah_local_datasource.dart';
import 'package:alquran_app/data/repositories/quran_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/database_helper.dart';

final locator = GetIt.instance;

void init() {
  // BLOC / CUBIT
  // `registerFactory` berarti instance baru dibuat setiap kali di-request
  locator.registerFactory(() => SurahCubit(locator()));

  // REPOSITORY
  // `registerLazySingleton` berarti instance hanya dibuat sekali saat pertama kali dibutuhkan
  locator.registerLazySingleton(() => QuranRepository(
        remoteDataSource: locator(),
        localDataSource: locator(),
      ));

  // DATA SOURCES
  locator.registerLazySingleton(() => SurahRemoteDatasource(client: locator()));
  locator.registerLazySingleton(
      () => SurahLocalDatasource(databaseHelper: locator()));

  // HELPERS / EXTERNAL
  locator.registerLazySingleton(() => DatabaseHelper.instance);
  locator.registerLazySingleton(() => http.Client());
}
