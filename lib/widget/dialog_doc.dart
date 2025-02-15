import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simplereader/bloc/pdf/pdf_bloc.dart';
import 'package:simplereader/cubit/theme_cubit.dart';
import 'package:simplereader/model/pdfmodel.dart';
import 'package:simplereader/widget/scaffold_messeger.dart';

class DialogDoc extends StatelessWidget {
  TextEditingController renameController = TextEditingController();
  Pdfmodel pdf;
  DialogDoc({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;

    return Theme(
      data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.text,
                    width: 1.5,
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.text,
                    width: 1.5,
                  )),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
      child: Wrap(
        runAlignment: WrapAlignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(144),
                      child: PdfDocumentViewBuilder.file(
                        pdf.path,
                        autoDispose: true,
                        builder: (context, document) => ListView.builder(
                          itemCount: 1,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return PdfPageView(
                              document: document,
                              pageNumber: index + 1,
                              alignment: Alignment.center,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Share.shareXFiles(
                        [XFile(pdf.path)],
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 50,
                      width: 290,
                      decoration: BoxDecoration(
                          color: const Color(0xff1b5ed1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Share',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            'assets/icons/share.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final dir = File(pdf.path);
                      final namePdf = dir.path.split('/').last;
                      renameController.text = namePdf.split('.pdf').first;
                      showDialog(
                        useSafeArea: true,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Rename Pdf',
                            style: TextStyle(color: theme.text),
                          ),
                          backgroundColor: theme.background,
                          content: TextFormField(
                            controller: renameController,
                            style: TextStyle(color: theme.text),
                          ),
                          actions: [
                            BlocListener<PdfBloc, PdfState>(
                              listener: (context, state) {
                                if (state is PdfRenameFile) {
                                  context.pop();
                                  context.pop();
                                  ShowSnackBar(context, 'Rename Succes')
                                      .showSnackBar(
                                          colors: const Color(0xff4fc63b));
                                }
                              },
                              child: TextButton(
                                  onPressed: () {

                                    context.read<PdfBloc>().add(OnPdfRename(
                                        newName: renameController.text,
                                        filePdf: dir));
                                  },
                                  child: const Text('Rename')),
                            )
                          ],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 50,
                      width: 290,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Rename',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            'assets/icons/Rename.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final dir = Directory(pdf.path);

                      context.read<PdfBloc>().add(OnPdfDeleted(filePdf: dir));
                      ShowSnackBar(context, 'Deleted Succes').showSnackBar();
                      context.pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 50,
                      width: 290,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Delete',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            'assets/icons/Delete.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
