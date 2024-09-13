// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:simplereader/bloc/pdf/pdf_bloc.dart';
import 'package:simplereader/bloc/switch_mode/switch_mode_bloc.dart';
import 'package:simplereader/model/pdfmodel.dart';
import 'package:simplereader/widget/appbar_pdf.dart';
import 'package:simplereader/widget/appbar_search.dart';

class ReadPDFScreens extends StatefulWidget {
  Pdfmodel pdf;
  static String routeName = '/ScreenPDF';
  ReadPDFScreens({
    super.key,
    required this.pdf,
  });

  @override
  State<ReadPDFScreens> createState() => _ReadPDFScreensState();
}

class _ReadPDFScreensState extends State<ReadPDFScreens> {
  TextEditingController textEditingController = TextEditingController();
  PdfViewerController pdfViewerController = PdfViewerController();
  int nextSearch = 0;

  late final PdfTextSearcher pdfTextSearcher;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<PdfBloc>().add(OnPdfCloseSearch()));
    pdfTextSearcher = PdfTextSearcher(pdfViewerController);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    pdfViewerController;
    pdfTextSearcher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFDFCFA),
        title: Visibility(
            visible: context.watch<PdfBloc>().state is PdfOpenSearch ||
                    context.watch<PdfBloc>().state is PdfSearchingText
                ? false
                : true,
            child: Text(widget.pdf.name)),
        leading: Visibility(
            visible:
                context.watch<PdfBloc>().state is PdfCloseSearch ? true : false,
            child: IconButton(
                onPressed: () async {
                  context.go('/');
                },
                icon: Image.asset('assets/icons/left-arrow.png'))),
        actions: [
          Builder(
            builder: (context) {
              final status = context.watch<PdfBloc>();
              if (!status.isOpen) {
                return AppBarPDF(
                  pdf: widget.pdf,
                  pdfViewerController: pdfViewerController,
                );
              } else if (status.isOpen) {
                return AppBarSearch(
                    pdfTextSearcher: pdfTextSearcher,
                    textEditingController: textEditingController);
              }
              return const SizedBox();
            },
          )
        ],
      ),
      body: BlocBuilder<SwitchModeBloc, SwitchModeState>(
        builder: (context, state) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.grey,
                state is ReaderMode ? BlendMode.saturation : BlendMode.dst),
            child: PdfViewer.file(
              widget.pdf.path,
              controller: pdfViewerController,
              params: PdfViewerParams(
                  enableTextSelection: true,
                  backgroundColor: const Color.fromARGB(255, 253, 252, 250),
                  viewerOverlayBuilder: (context, size) => [
                        PdfViewerScrollThumb(
                          controller: pdfViewerController,
                          thumbBuilder:
                              (context, thumbSize, pageNumber, controller) =>
                                  Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black54),
                          ),
                        ),
                      ],
                  loadingBannerBuilder:
                      (context, bytesDownloaded, totalBytes) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                  onPageChanged: (pageNumber) => Center(
                        child: Text(pageNumber.toString()),
                      ),
                  pagePaintCallbacks: [
                    pdfTextSearcher.pageTextMatchPaintCallback
                  ]),
            ),
          );
        },
      ),
    );
  }
}


// BlocBuilder<PdfBloc, PdfState>(
//             buildWhen: (previous, current) =>
//                 (previous is PdfInitial) && (current is PdfCloseSearch) ||
//                 (previous is PdfCloseSearch) && (current is PdfOpenSearch) ||
//                 (previous is PdfOpenSearch) && (current is PdfCloseSearch) ||
//                 (previous is PdfSearchingText) && (current is PdfCloseSearch),
//             builder: (context, state) {
//               if (state is PdfCloseSearch) {
//                 return AppBarPDF(
//                   pdf: widget.pdf,
//                   pdfViewerController: pdfViewerController,
//                 );
//               } else if (state is PdfOpenSearch) {
//                 return AppBarSearch(
//                     pdfTextSearcher: pdfTextSearcher,
//                     textEditingController: textEditingController);
//               }
//               return const SizedBox();
//             },
//           )