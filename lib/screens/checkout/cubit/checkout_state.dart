part of 'checkout_cubit.dart';

@immutable
abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}


class ChangeRestState extends CheckoutState {}

class InsertSuccessState extends CheckoutState {}

class InsertErrorState extends CheckoutState {}

class CreateReceiptDateDatabseSuccessfullyState extends CheckoutState{}

class CreateReceiptDateDatabseErrorState extends CheckoutState{}

class CreateReceiptDetailsDatabseSuccessfullyState extends CheckoutState{}

class CreateReceiptDetailsDatabseErrorState extends CheckoutState{}

class InsertIntoReceiptDateDatabseSuccessfullyState extends CheckoutState{}

class InsertIntoReceiptDateDatabseErrorState extends CheckoutState{}

class InsertIntoReceiptDetailsDatabseSuccessfullyState extends CheckoutState{}

class InsertIntoReceiptDetailsDatabseErrorState extends CheckoutState{}
