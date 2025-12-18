import 'package:equatable/equatable.dart';

abstract class PdfListEvent extends Equatable {
  const PdfListEvent();
  @override
  List<Object?> get props => [];
}

class LoadPdfList extends PdfListEvent {}

class DeletePdfEvent extends PdfListEvent {
  final String path;
  const DeletePdfEvent(this.path);
  @override
  List<Object?> get props => [path];
}
