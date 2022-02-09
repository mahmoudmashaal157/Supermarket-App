import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supermarkett/models/products_model.dart';

part 'details_of_daily_receipt_state.dart';

class DetailsOfDailyReceiptCubit extends Cubit<DetailsOfDailyReceiptState> {
  DetailsOfDailyReceiptCubit() : super(DetailsOfDailyReceiptInitial());

  var database;
  List<Map<String,dynamic>>products=[];
  List<ProductsModel>productDetails=[];

  static DetailsOfDailyReceiptCubit get(context)=>BlocProvider.of(context);

  void getTheMonthlySelles({
    required String id,
  }){
    products=[];
    openDatabase(
        "ReceiptDatabase.db"
    ).then((value) {
      database=value;
      value.rawQuery("SELECT * FROM Receipt WHERE ID = $id").then((value) {
        value.forEach((element) {
          products.add(element);
          String details = element["PRODUCTS"] as String;
          var detailsDecoded = jsonDecode(details) as List;
          productDetails = detailsDecoded.map((e) => ProductsModel.fromJson(e)).toList();
        });
        emit(GetReceiptDetailsSuccessfullyState());
        print(products.length);
      }).catchError((error){
        emit(GetReceiptDetailsErrorState());
        print(error);
      });
    }).catchError((error){
    });

  }
}
