import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "alquran.db";
  static const _databaseVersion = 1;
  static const tableSurah = 'surah';
  static const columnNomor = 'nomor';
  static const columnNama = 'nama';
  static const columnNamaLatin = 'namaLatin';
  static const columnJumlahAyat = 'jumlahAyat';
  static const columnTempatTurun = 'tempatTurun';
  static const columnArti = 'arti';
  static const columnDeskripsi = 'deskripsi';
  static const columnAudio = 'audio';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableSurah (
        $columnNomor INTEGER PRIMARY KEY,
        $columnNama TEXT NOT NULL,
        $columnNamaLatin TEXT NOT NULL,
        $columnJumlahAyat INTEGER NOT NULL,
        $columnTempatTurun TEXT NOT NULL,
        $columnArti TEXT NOT NULL,
        $columnDeskripsi TEXT NOT NULL,
        $columnAudio TEXT NOT NULL
      )
    ''');
  }
}
