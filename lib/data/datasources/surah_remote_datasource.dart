import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../models/surah_detail_model.dart';
import '../models/surah_model.dart';

class SurahRemoteDatasource {
  final http.Client client;

  SurahRemoteDatasource({required this.client});

//   Future<Either<String, List<SurahModel>>> getAllSurah() async {
//     try {
//       final response =
//           await client.get(Uri.parse('https://equran.id/api/v2/surat'));
//       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       if (jsonResponse['data'] is List) {
//         return Right((jsonResponse['data'] as List)
//             .map((x) => SurahModel.fromMap(x as Map<String, dynamic>))
//             .toList());
//       } else {
//         return Left(
//             'Gagal terhubung ke server. Kode Error: ${response.statusCode}');
//       }
//     } on SocketException {
//       return const Left(
//           'Tidak ada koneksi internet. Untuk pertama kali menggunakan aplikasi, pastikan Anda terhubung ke internet.');
//     } catch (e) {
//       return Left('Terjadi kesalahan yang tidak diketahui: ${e.toString()}');
//     }
//   }

//   Future<Either<String, SurahDetailModel>> getDetailSurah(
//       int surahNumber) async {
//     try {
//       final response = await client
//           .get(Uri.parse('https://equran.id/api/v2/surat/$surahNumber'));
//       Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       if (jsonResponse['data'] is Map) {
//         return Right(SurahDetailModel.fromMap(
//             jsonResponse['data'] as Map<String, dynamic>));
//       } else {
//         return const Left('Format data detail dari server tidak sesuai.');
//       }
//     } catch (e) {
//       return Left(e.toString());
//     }
//   }
// }

  Future<Either<String, List<SurahModel>>> getAllSurah() async {
    final uri = Uri.parse('https://equran.id/api/v2/surat');
    try {
      final response = await client.get(uri);

      // 2. Tambahkan pengecekan status code!
      if (response.statusCode == 200) {
        // Logika parsing JSON hanya dijalankan jika request berhasil
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['data'] is List) {
          final surahs = (jsonResponse['data'] as List)
              .map((x) => SurahModel.fromMap(x as Map<String, dynamic>))
              .toList();
          return Right(surahs);
        } else {
          return const Left('Format data dari server tidak sesuai.');
        }
      } else {
        // Jika server mengembalikan error (bukan 200)
        return Left(
            'Gagal terhubung ke server. Kode Error: ${response.statusCode}');
      }
    } on SocketException {
      // 3. Tangani error koneksi internet secara spesifik
      return const Left(
          'Tidak ada koneksi internet. Pertama kali menggunakan aplikasi, pastikan Anda terhubung ke internet.');
    } catch (e) {
      // 4. Tangani semua error tak terduga lainnya
      return Left('Terjadi kesalahan yang tidak diketahui: ${e.toString()}');
    }
  }

  Future<Either<String, SurahDetailModel>> getDetailSurah(
      int surahNumber) async {
    final uri = Uri.parse('https://equran.id/api/v2/surat/$surahNumber');
    try {
      final response = await client.get(uri);

      // 2. Tambahkan pengecekan status code!
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['data'] is Map<String, dynamic>) {
          final detail = SurahDetailModel.fromMap(
              jsonResponse['data'] as Map<String, dynamic>);
          return Right(detail);
        } else {
          return const Left('Format data detail dari server tidak sesuai.');
        }
      } else {
        return Left(
            'Gagal memuat detail surah. Kode Error: ${response.statusCode}');
      }
    } on SocketException {
      // 3. Tangani error koneksi internet secara spesifik
      return const Left(
          'Tidak ada koneksi internet. Pertama kali menggunakan aplikasi, pastikan Anda terhubung ke internet.');
    } catch (e) {
      // 4. Tangani semua error tak terduga lainnya
      return Left('Terjadi kesalahan yang tidak diketahui: ${e.toString()}');
    }
  }
}
