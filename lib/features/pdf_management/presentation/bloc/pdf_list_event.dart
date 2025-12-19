import 'package:equatable/equatable.dart';

abstract class PdfListEvent extends Equatable {
  const PdfListEvent();
  @override
  List<Object?> get props => [];
}

class LoadPdfList extends PdfListEvent {}

class DeletePdfEvent extends PdfListEvent {
  final int id;
  const DeletePdfEvent(this.id);
  @override
  List<Object?> get props => [id];
}
