import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:path/path.dart' as path;
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
          if (results != null) {
            final isPdf = results.path.contains('.pdf');

            if (isPdf) {
              context.go(ReadPDFScreens.routeName, extra: results);
            } else {
              SnackBar snackBar =
                  const SnackBar(content: Text('This not documents'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              log('Not Pdf');
            }
          }
          emit(results);
        },
      );

  void findPdf() async => await serviceFile.findPDFAll().then(
        (value) {
          for (var element in value) {
            log('PDF found: $element');
          }
          emit(value);
        },
      );
}
