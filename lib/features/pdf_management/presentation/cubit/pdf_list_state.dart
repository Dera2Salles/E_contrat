import 'package:equatable/equatable.dart';
import 'package:e_contrat/features/pdf_management/domain/entities/pdf_document.dart';

class PdfListState extends Equatable {
  final bool isLoading;
  final List<PdfDocument> items;
  final String? errorMessage;

  const PdfListState({
    required this.isLoading,
    required this.items,
    required this.errorMessage,
  });

  const PdfListState.initial()
      : isLoading = false,
        items = const [],
        errorMessage = null;

  PdfListState copyWith({
    bool? isLoading,
    List<PdfDocument>? items,
    String? errorMessage,
  }) {
    return PdfListState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, errorMessage];
}
