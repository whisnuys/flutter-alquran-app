import 'package:flutter/material.dart';
import 'package:flutter_ahlul_quran_app/common/contants.dart';
import 'package:flutter_ahlul_quran_app/cubit/surah/surah_cubit.dart';
import 'package:flutter_ahlul_quran_app/ui/verse_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  @override
  void initState() {
    context.read<SurahCubit>().getAllSurah();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Surah'),
      ),
      body: BlocBuilder<SurahCubit, SurahState>(builder: (context, state) {
        if (state is SurahLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SurahLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final surah = state.listSurah[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VersePage(surah: surah);
                      },
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '${surah.nomor}',
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ),
                    title: Text('${surah.namaLatin} - ${surah.nama}'),
                    subtitle: Text('${surah.arti}, ${surah.jumlahAyat} Verse.'),
                  ),
                ),
              );
            },
            itemCount: state.listSurah.length,
          );
        }
        if (state is SurahError) {
          return Center(
            child: Text(state.message),
          );
        }

        return const Center(
          child: Text('No Data'),
        );
      }),
    );
  }
}
