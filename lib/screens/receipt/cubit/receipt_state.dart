part of 'receipt_cubit.dart';

@immutable
abstract class ReceiptState {}

class ReceiptInitial extends ReceiptState {}

class AddProductToReceipt extends ReceiptState{}

class CreateDataBaseSuccessfullyState extends ReceiptState{}

class CreateDataBaseErrorState extends ReceiptState{}

class OpenDataBaseSuccessfullyState extends ReceiptState{}

class GetFromDataBaseSuccessfullyState extends ReceiptState{}

class GetFromDataBaseErrorState extends ReceiptState{}

class CalculateTheTotalOfOneProduct extends ReceiptState{}

class ShowAddQuantityState extends ReceiptState{}

class HideAddQuantityState extends ReceiptState{}

class RemoveItemFromListState extends ReceiptState{}

class EmptyTheListState extends ReceiptState{}







