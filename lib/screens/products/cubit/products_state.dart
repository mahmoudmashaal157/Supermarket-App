part of 'products_cubit.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ShowAddProductDialogState extends ProductsState{}

class HideAddProductDialogState extends ProductsState{}

class ShowSubtractProductDialogState extends ProductsState{}

class HideSubtractProductDialogState extends ProductsState{}

class CreateDataBaseSuccessfullyState extends ProductsState{}

class OpenDataBaseSuccessfullyState extends ProductsState{}

class CreateDataBaseErrorState extends ProductsState{}

class GetFromDataBaseSuccessfullyState extends ProductsState{}

class GetFromDataBaseErrorState extends ProductsState{}

class InsertIntoDataBaseSuccessfullyState extends ProductsState{}

class InsertIntoDataBaseErrorState extends ProductsState{}

class UpdateInDataBaseSuccessFullyState extends ProductsState{}

class UpdateInDataBaseErrorState extends ProductsState{}

class DeleteFromDataBaseSuccessfullyState extends ProductsState{}

class DeleteFromDataBaseErrorState extends ProductsState{}

class ShowSearchBarState extends ProductsState{}

class HideSearchBarState extends ProductsState{}

class SearchSuccessfullyState extends ProductsState{}

class SearchErrorState extends ProductsState{}

class UpdateAfterSellSuccessfullyState extends ProductsState{}

class UpdateAfterSellErrorState extends ProductsState{}

class IdExistedErrorState extends ProductsState{}

class ShowUpdateNameDialogState extends ProductsState{}

class ShowUpdatePriceDialogState extends ProductsState{}

class HideUpdateNameDialogState extends ProductsState{}

class HideUpdatePriceDialogState extends ProductsState{}

class UpdateNameSuccessfullyState extends ProductsState{}

class UpdateNameErrorState extends ProductsState{}

class UpdatePriceSuccessfullyState extends ProductsState{}

class UpdatePriceErrorState extends ProductsState{}











