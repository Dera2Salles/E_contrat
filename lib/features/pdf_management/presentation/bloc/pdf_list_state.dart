import 'package:equatable/equatable.dart';

abstract class PdfListState extends Equatable {
  const PdfListState();

  @override
  List<Object?> get props => [];
}

class PdfListInitial extends PdfListState {}

class PdfListLoading extends PdfListState {}

class PdfListLoaded extends PdfListState {
  final List<dynamic> pdfs;

  const PdfListLoaded(this.pdfs);

  @override
  List<Object?> get props => [pdfs];
}

class PdfListError extends PdfListState {
  final String message;

  const PdfListError(this.message);

  @override
  List<Object?> get props => [message];
}
