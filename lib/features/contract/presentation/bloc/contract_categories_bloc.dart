import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_contract_categories.dart';
import 'contract_categories_event.dart';
import 'contract_categories_state.dart';

class ContractCategoriesBloc extends Bloc<ContractCategoriesEvent, ContractCategoriesState> {
  final GetContractCategories getContractCategories;

  ContractCategoriesBloc({required this.getContractCategories}) : super(ContractCategoriesInitial()) {
    on<LoadContractCategories>(_onLoad);
  }

  Future<void> _onLoad(LoadContractCategories event, Emitter<ContractCategoriesState> emit) async {
    emit(ContractCategoriesLoading());
    try {
      final items = await getContractCategories();
      emit(ContractCategoriesLoaded(items));
    } catch (e) {
      emit(const ContractCategoriesError('Failed to load categories'));
    }
  }
}
