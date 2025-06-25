import 'dart:convert';

class SurahModel {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  Map<String, String> audioFull;

  SurahModel({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  });

  factory SurahModel.fromJson(String str) {
    var decodedJson = json.decode(str);
    if (decodedJson is Map<String, dynamic>) {
      return SurahModel.fromMap(decodedJson);
    } else {
      throw Exception('Decoded JSON is not a Map');
    }
  }

  String toJson() => json.encode(toMap());

  factory SurahModel.fromMap(Map<String, dynamic> json) => SurahModel(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        // audioFull: Map.from(json["audioFull"])
        //     .map((k, v) => MapEntry<String, String>(k, v)),
        audioFull: Map<String, String>.from(json["audioFull"] ?? {}),
      );

  Map<String, dynamic> toMap() => {
        "nomor": nomor,
        "nama": nama,
        "namaLatin": namaLatin,
        "jumlahAyat": jumlahAyat,
        "tempatTurun": tempatTurun,
        "arti": arti,
        "deskripsi": deskripsi,
        // "audioFull":
        //     Map.from(audioFull).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "audio": audioFull['05'] ?? '',
      };
}

enum TempatTurun { MADINAH, MEKAH }

final tempatTurunValues =
    EnumValues({"madinah": TempatTurun.MADINAH, "mekah": TempatTurun.MEKAH});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
