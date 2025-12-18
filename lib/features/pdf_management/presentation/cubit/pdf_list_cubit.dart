import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_contrat/features/pdf_management/domain/usecases/delete_pdf.dart';
import 'package:e_contrat/features/pdf_management/domain/usecases/get_all_pdfs.dart';

import 'pdf_list_state.dart';

class PdfListCubit extends Cubit<PdfListState> {
  final GetAllPdfs _getAll;
  final DeletePdf _delete;

  PdfListCubit(this._getAll, this._delete) : super(const PdfListState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final items = await _getAll();
      emit(state.copyWith(isLoading: false, items: items, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> delete(int id) async {
    try {
      await _delete(id);
      await load();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
