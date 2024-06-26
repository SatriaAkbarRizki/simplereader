import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplereader/bloc/pdf/pdf_bloc.dart';
import 'package:simplereader/bloc/switch_mode/switch_mode_bloc.dart';

import 'package:simplereader/cubit/file_cubit.dart';
import 'package:simplereader/navigation/navbar.dart';
import 'package:simplereader/pdfbloc_observer.dart';

import 'package:simplereader/theme/mytheme.dart';

import 'cubit/navbar_cubit.dart';

void main() {
  Bloc.observer = PdfBlocObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PdfBloc()),
        BlocProvider(
          create: (context) => SwitchModeBloc(),
        ),
        BlocProvider(
          create: (context) => FileCubit(),
        ),
        BlocProvider(
          create: (context) => NavbarCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyTheme().lightTheme,
        home: Navbar(),
      ),
    );
  }
}
