import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simplereader/service/filedoc.dart';

import '../screens/readingpdf.dart';

class FileCubit extends Cubit<dynamic> {
  FileCubit() : super(null);
  ServiceFile serviceFile = ServiceFile();

  void getFile(BuildContext context) async =>
      await serviceFile.getFileDoc().then(
        (results) {
          if (results != null && context.mounted) {
            final isPdf = results.path.contains('.pdf');

            if (isPdf) {
              context.go(ReadPDFScreens.routeName, extra: results);
            } else {
              SnackBar snackBar =
                  const SnackBar(content: Text('This not documents'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            }
          }
          emit(results);
        },
      );

  void findPdf() async => await serviceFile.findPDFAll().then(
        (value) {
          emit(value);
        },
      );
}
