import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_contrat/features/contract/get_contract_categories.dart';

import 'contract_categories_state.dart';

class ContractCategoriesCubit extends Cubit<ContractCategoriesState> {
  final GetContractCategories _getCategories;

  ContractCategoriesCubit(this._getCategories)
      : super(const ContractCategoriesState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final items = await _getCategories();
      emit(state.copyWith(isLoading: false, items: items));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
