import 'package:equatable/equatable.dart';

abstract class ContractCategoriesEvent extends Equatable {
  const ContractCategoriesEvent();
  @override
  List<Object?> get props => [];
}

class LoadContractCategories extends ContractCategoriesEvent {}
