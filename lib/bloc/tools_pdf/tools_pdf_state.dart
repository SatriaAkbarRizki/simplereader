part of 'tools_pdf_bloc.dart';

@immutable
sealed class ToolsPdfState {}

final class ToolsPdfInitial extends ToolsPdfState {}

final class ToolsPickPdfMerge extends ToolsPdfState {
  final Pdfmodel? pdf;

  ToolsPickPdfMerge(this.pdf);
}

final class ToolsRunning extends ToolsPdfState {}

final class ToolsSucces extends ToolsPdfState {}

final class ToolsOnPdfMerge extends ToolsPdfState {}

final class ToolsCancelMerge extends ToolsPdfState {}