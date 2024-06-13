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
          await client.get(Uri.parse('https://equran.id/api/surat'));
      return Right(List<SurahModel>.from(
              jsonDecode(response.body).map((x) => SurahModel.fromMap(x)))
          .toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, SurahDetailModel>> getDetailSurah(
      int surahNumber) async {
    try {
      final response = await client
          .get(Uri.parse('https://equran.id/api/surat/$surahNumber'));
      return Right(SurahDetailModel.fromMap(jsonDecode(response.body)));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
