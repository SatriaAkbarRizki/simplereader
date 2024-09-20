import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplereader/cubit/navbar_cubit.dart';
import 'package:simplereader/widget/title_profile.dart';
import 'package:simplereader/widget/title_tools.dart';

import '../cubit/theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = context.watch<ThemeCubit>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleProfile(
                  title: 'Hi, Bro, Good Morning 🌄',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: const Color(0xff1b5ed1), width: 2)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: themes.state.text,
                                    fontWeight: FontWeight.w900),
                          ),
                          Text(
                              "let's view, delete,split, watermark or set password for your pdf  ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: themes.state.text,
                                  ))
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TitleProfile(
                    title: 'Color themes',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xff1b5ed1), width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: themes.listColorTheme.length,
                        itemBuilder: (context, index) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => themes.chanetTheme(index),
                              child: Container(
                                height: 35,
                                width: 35,
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                    color:
                                        themes.listColorTheme[index].background,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: TitleProfile(
                    title: 'Tools PDF',
                  ),
                ),
                GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                  ),
                  children: const [
                    TitleTools('Merging', 'assets/icons/merge.png'),
                    TitleTools(
                        'Deleting Page ', 'assets/icons/delete_page.png'),
                    TitleTools('Compressing', 'assets/icons/sort-down.png'),
                    TitleTools('Watermark', 'assets/icons/face-mask.png')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
