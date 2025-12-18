import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_category.dart';

abstract class ContractCategoriesState extends Equatable {
  const ContractCategoriesState();
  @override
  List<Object?> get props => [];
}

class ContractCategoriesInitial extends ContractCategoriesState {}

class ContractCategoriesLoading extends ContractCategoriesState {}

class ContractCategoriesLoaded extends ContractCategoriesState {
  final List<ContractCategory> items;
  const ContractCategoriesLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class ContractCategoriesError extends ContractCategoriesState {
  final String message;
  const ContractCategoriesError(this.message);
  @override
  List<Object?> get props => [message];
}
