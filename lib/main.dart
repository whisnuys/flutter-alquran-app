import 'package:alquran_app/data/datasources/surah_remote_datasource.dart';
import 'package:alquran_app/data/repositories/quran_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'injection_container.dart' as di;

import 'cubit/surah/surah_cubit.dart';
import 'cubit/verse/verse_cubit.dart';
import 'ui/home_page.dart';
import 'ui/splash_page.dart';
import 'ui/surah_page.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => di.locator<SurahCubit>(),
            ),
            BlocProvider(
              create: (context) => VerseCubit(
                SurahRemoteDatasource(client: http.Client()),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ahlul Quran App',
            theme: ThemeData(
              primarySwatch: Colors.brown,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            home: const SplashPage(),
            routes: {
              '/home': (context) => const HomePage(),
              '/surah': (context) => const SurahPage(),
            },
          ),
        );
      },
    );
  }
}
