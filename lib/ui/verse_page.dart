import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/contants.dart';
import '../cubit/verse/verse_cubit.dart';
import '../data/models/surah_model.dart';

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
    final scrollController = ScrollController();
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<VerseCubit, VerseState>(
          builder: (context, state) {
            if (state is VerseLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is VerseLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300.h,
                    pinned: true,
                    primary: false,
                    backgroundColor: AppColors.white,
                    surfaceTintColor: AppColors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      centerTitle: false,
                      titlePadding:
                          EdgeInsets.only(left: 24.w, right: 24.w, top: 10.h),
                      title: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20.w, top: 1.h),
                            child: Text(
                              "${state.detail.namaLatin}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16.h),
                            padding: const EdgeInsets.all(20),
                            height: 240.h,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/header_verse.png'),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                Text(
                                  "${state.detail.arti}",
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                SizedBox(
                                  width: 180.w,
                                  child: Divider(
                                    color: AppColors.white.withOpacity(0.5),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "${state.detail.tempatTurun!.toUpperCase()} - ${state.detail.jumlahAyat} Ayat",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ListView.separated(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final verse = state.detail.ayat![index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundColor: AppColors.primary,
                            //   child: Text(
                            //     '${verse.nomor}',
                            //     style: const TextStyle(color: AppColors.white),
                            //   ),
                            // ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.primary,
                                        child: Text(
                                          '${verse.nomor}',
                                          style: const TextStyle(
                                              color: AppColors.white),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/ic_bookmark.png',
                                        width: 24.w,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 18.h),
                                Text(
                                  '${verse.ar}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 18.h),
                              ],
                            ),

                            subtitle: Text(
                              '${verse.idn}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black.withOpacity(0.8)),
                            ),
                          ),
                        );
                      },
                      itemCount: state.detail.ayat!.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is VerseError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(
              child: Text('No Data'),
            );
          },
        ),
      ),
    );
  }
}
