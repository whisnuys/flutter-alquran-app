import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'models/surah_detail_model.dart';
import 'models/surah_model.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<Either<String, List<SurahModel>>> getAllSurah() async {
    try {
      final response =
          await client.get(Uri.parse('https://equran.id/api/v2/surat'));
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data'] is List) {
        return Right((jsonResponse['data'] as List)
            .map((x) => SurahModel.fromMap(x as Map<String, dynamic>))
            .toList());
      } else {
        return Left('Data is not a list');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SurahDetailModel>> getDetailSurah(
      int surahNumber) async {
    try {
      final response = await client
          .get(Uri.parse('https://equran.id/api/v2/surat/$surahNumber'));
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data'] is Map) {
        return Right(SurahDetailModel.fromMap(
            jsonResponse['data'] as Map<String, dynamic>));
      } else {
        return Left('Data is not a map');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
