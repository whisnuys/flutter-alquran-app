import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/contants.dart';
import '../cubit/surah/surah_cubit.dart';
import 'verse_page.dart';

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
    final scrollController = ScrollController();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180.h,
                pinned: true,
                backgroundColor: AppColors.white,
                surfaceTintColor: AppColors.white,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  centerTitle: false,
                  titlePadding:
                      EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
                  title: ListView(
                    children: [
                      Text(
                        'Assalamualaikum',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: EdgeInsets.only(top: 16.h),
                        height: 120.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/header.png'),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Terakhir dibaca",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Text(
                              "Al-Baqarah",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Ayat 80",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                pinned: true,
                primary: false,
                backgroundColor: AppColors.white,
                surfaceTintColor: AppColors.white,
                automaticallyImplyLeading: false,
                title: TabBar(
                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.grey,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(
                      text: 'Surah',
                    ),
                    Tab(
                      text: 'Juz',
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<SurahCubit, SurahState>(
                    builder: (context, state) {
                  if (state is SurahLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is SurahLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      controller: scrollController,
                      shrinkWrap: true,
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
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 0),
                            leading: Container(
                              width: 36.w,
                              height: 36.h,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/number_frame.png',
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${surah.nomor}',
                                  style:
                                      const TextStyle(color: AppColors.primary),
                                ),
                              ),
                            ),
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        surah.namaLatin,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        surah.arti,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    surah.nama,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            // title: Text('${surah.namaLatin} - ${surah.nama}'),
                            // subtitle:
                            //     Text('${surah.arti}, ${surah.jumlahAyat} Verse.'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
