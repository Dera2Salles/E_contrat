import 'package:equatable/equatable.dart';
import 'package:e_contrat/features/contract/domain/entities/contract_category.dart';

class ContractCategoriesState extends Equatable {
  final bool isLoading;
  final List<ContractCategory> items;
  final String? errorMessage;

  const ContractCategoriesState({
    required this.isLoading,
    required this.items,
    required this.errorMessage,
  });

  const ContractCategoriesState.initial()
      : isLoading = false,
        items = const [],
        errorMessage = null;

  ContractCategoriesState copyWith({
    bool? isLoading,
    List<ContractCategory>? items,
    String? errorMessage,
  }) {
    return ContractCategoriesState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, errorMessage];
}
