import 'package:flutter/material.dart';
import 'package:flutter_ahlul_quran_app/common/contants.dart';
import 'package:flutter_ahlul_quran_app/cubit/verse/verse_cubit.dart';
import 'package:flutter_ahlul_quran_app/data/models/surah_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VersePage extends StatefulWidget {
  const VersePage({super.key, required this.surah});

  final SurahModel surah;

  @override
  State<VersePage> createState() => _VersePageState();
}

class _VersePageState extends State<VersePage> {
  @override
  void initState() {
    context.read<VerseCubit>().getDetailSurah(widget.surah.nomor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.namaLatin),
      ),
      body: BlocBuilder<VerseCubit, VerseState>(builder: (context, state) {
        if (state is VerseLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is VerseLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final verse = state.detail.ayat![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '${verse.nomor}',
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                title: Text(
                  '${verse.ar}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${verse.idn}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
            itemCount: state.detail.ayat!.length,
          );
        }
        if (state is VerseError) {
          return Center(
            child: Text(state.message),
          );
        }

        return const Center(
          child: Text('no data'),
        );
      }),
    );
  }
}
