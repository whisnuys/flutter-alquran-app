import 'package:alquran_app/data/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'cubit/surah/surah_cubit.dart';
import 'cubit/verse/verse_cubit.dart';
import 'ui/home_page.dart';
import 'ui/splash_page.dart';
import 'ui/surah_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
              create: (context) => SurahCubit(
                ApiService(client: http.Client()),
              ),
            ),
            BlocProvider(
              create: (context) => VerseCubit(
                ApiService(client: http.Client()),
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
