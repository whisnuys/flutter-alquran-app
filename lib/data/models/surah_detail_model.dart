import 'dart:convert';

class SurahDetailModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;
  final List<AyatModel> ayat;
  final SuratSelanjutnya? suratSelanjutnya; // Dibuat nullable
  final bool suratSebelumnya;

  SurahDetailModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
    required this.ayat,
    this.suratSelanjutnya,
    required this.suratSebelumnya,
  });

  // Factory dari API JSON (dibuat jauh lebih aman)
  factory SurahDetailModel.fromMap(Map<String, dynamic> json) {
    // Penanganan khusus untuk suratSelanjutnya yang bisa berupa 'false' (boolean) atau Map
    final nextSurahData = json["suratSelanjutnya"];
    SuratSelanjutnya? nextSurah;
    if (nextSurahData is Map<String, dynamic>) {
      nextSurah = SuratSelanjutnya.fromMap(nextSurahData);
    }

    return SurahDetailModel(
      nomor: json["nomor"] ?? 0,
      nama: json["nama"] ?? '',
      namaLatin: json["namaLatin"] ?? '',
      jumlahAyat: json["jumlahAyat"] ?? 0,
      tempatTurun: json["tempatTurun"] ?? '',
      arti: json["arti"] ?? '',
      deskripsi: json["deskripsi"] ?? '',
      audioFull: Map<String, String>.from(json["audioFull"] ?? {}),
      ayat: json["ayat"] == null
          ? []
          : List<AyatModel>.from(json["ayat"].map((x) => AyatModel.fromMap(x))),
      suratSelanjutnya: nextSurah,
      suratSebelumnya:
          json["suratSebelumnya"] is bool ? json["suratSebelumnya"] : false,
    );
  }
}

class AyatModel {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  AyatModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  // Factory untuk parsing dari API JSON (Dibuat lebih aman dengan null safety)
  factory AyatModel.fromMap(Map<String, dynamic> json) => AyatModel(
        nomorAyat: json["nomorAyat"] ?? 0,
        teksArab: json["teksArab"] ?? '',
        teksLatin: json["teksLatin"] ?? '',
        teksIndonesia: json["teksIndonesia"] ?? '',
        audio: Map<String, String>.from(json["audio"] ?? {}),
      );

  // --- METODE BARU UNTUK DATABASE ---

  // 1. Mengubah objek menjadi Map untuk disimpan ke SQFlite
  // Perhatikan bagaimana kita "meratakan" data: audio menjadi string, dan kita tambahkan surahNomor
  Map<String, dynamic> toDbMap(int surahNomor) => {
        "nomorAyat": nomorAyat,
        "teksArab": teksArab,
        "teksLatin": teksLatin,
        "teksIndonesia": teksIndonesia,
        "audio":
            audio['05'] ?? '', // Simpan hanya URL audio dari Misyari Rasyid
        "surah_nomor": surahNomor, // Simpan foreign key ke tabel surah
      };

  // 2. Factory untuk membuat objek dari data Map yang dibaca dari SQFlite
  factory AyatModel.fromDbMap(Map<String, dynamic> map) => AyatModel(
        nomorAyat: map["nomorAyat"],
        teksArab: map["teksArab"],
        teksLatin: map["teksLatin"],
        teksIndonesia: map["teksIndonesia"],
        // Buat ulang map audio dari string yang disimpan
        audio: {'05': map["audio"]},
      );
}

class SuratSelanjutnya {
  int nomor;
  String nama;
  String namaLatin;
  int jumlahAyat;

  SuratSelanjutnya({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
  });

  factory SuratSelanjutnya.fromJson(String str) =>
      SuratSelanjutnya.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SuratSelanjutnya.fromMap(Map<String, dynamic> json) =>
      SuratSelanjutnya(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
      );

  Map<String, dynamic> toMap() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
      };
}
