import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../delete_pdf.dart';
import '../../get_all_pdfs.dart';
import 'pdf_list_event.dart';
import 'pdf_list_state.dart';

@injectable
class PdfListBloc extends Bloc<PdfListEvent, PdfListState> {
  final GetAllPdfs getAllPdfs;
  final DeletePdf deletePdf;

  PdfListBloc({
    required this.getAllPdfs,
    required this.deletePdf,
  }) : super(PdfListInitial()) {
    on<LoadPdfList>(_onLoad);
    on<DeletePdfEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadPdfList event, Emitter<PdfListState> emit) async {
    emit(PdfListLoading());
    try {
      final pdfs = await getAllPdfs();
      emit(PdfListLoaded(pdfs));
    } catch (e) {
      emit(const PdfListError('Failed to load PDFs'));
    }
  }

  Future<void> _onDelete(DeletePdfEvent event, Emitter<PdfListState> emit) async {
    try {
      await deletePdf(event.id);
      add(LoadPdfList());
    } catch (e) {
      emit(const PdfListError('Failed to delete PDF'));
    }
  }
}
