import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:simplereader/bloc/pdf/pdf_bloc.dart';
import 'package:simplereader/bloc/tools_pdf/cubit/channel_home.dart';
import 'package:simplereader/cubit/theme_cubit.dart';
import 'package:simplereader/pdfbloc_observer.dart';
import 'package:simplereader/screens/empty.dart';
import 'package:simplereader/screens/readingpdf.dart';
import 'package:simplereader/type/empty_type.dart';
import 'package:simplereader/widget/dialog_doc.dart';

class ListPDF extends StatelessWidget {
  const ListPDF({super.key});

  @override
  Widget build(BuildContext context) {
    final listPdf = context.watch<PdfBloc>().listPdf;
    final themes = context.watch<ThemeCubit>().state;
    return BlocConsumer<PdfBloc, PdfState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isHome = context.watch<ChannelHome>().state;
        if (isHome && state is! PdfInitial) {
          context.read<PdfBloc>().add(OnPdfInitial());
          context.read<ChannelHome>().onceFetch();
        }
        if (listPdf.isNotEmpty) {
          return CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 2),
                delegate: SliverChildBuilderDelegate(
                  childCount: listPdf.length,
                  (context, index) => GestureDetector(
                    onTap: () => context.push(ReadPDFScreens.routeName,
                        extra: listPdf[index]),
                    onLongPress: () => showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) => DialogDoc(
                        pdf: listPdf[index],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 10,
                          ),
                          height: 220,
                          decoration: BoxDecoration(boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ], borderRadius: BorderRadius.circular(12)),
                          child: PdfDocumentViewBuilder.file(
                            listPdf[index].path,
                            builder: (context, document) => ListView.builder(
                              itemCount: 1,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: PdfPageView(
                                    document: document,
                                    pageNumber: index + 1,
                                    alignment: Alignment.center,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 10,
                            ),
                            child: Text(
                              listPdf[index].name,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: themes.text),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        } else {
          return const EmptyScreens(type: TypeEmpty.emptyPdf);
        }
      },
    );
  }
}
