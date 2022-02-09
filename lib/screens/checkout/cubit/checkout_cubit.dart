import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supermarkett/network/local/cache_helper/cache_helper.dart';
import 'package:supermarkett/screens/products/cubit/products_cubit.dart';
part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  static CheckoutCubit get(context)=>BlocProvider.of(context);

  String rest = "0";
  var receiptDatabase ;
  var receiptDetailsDatabase;
  int id=0;
  void caulateTheRest(double total ,String payed){
    if(payed.isEmpty){
      rest ="0";
      emit(ChangeRestState());
    }
    else if(double.parse(payed) > total){
      rest = (double.parse(payed)-total).toString();
      emit(ChangeRestState());
    }
    else if (double.parse(payed) <= total){
      rest="0";
      emit(ChangeRestState());
    }
  }

  bool checkTheRest(double total,String rest){
    double rt = double.parse(rest);
    if(rt>=total){
      return true;
    }
    else {
      return false;
    }
  }

  void createReceiptDateDatabse(){
    openDatabase(
      "ReceiptDatabase.db",
      version: 1,
      onCreate: (db, version) {
        receiptDatabase=db;
        print("ReceiptData database Created");
        db.execute("CREATE TABLE Receipt (ID INTEGER PRIMARY KEY ,DAY TEXT,MONTH TEXT,YEAR TEXT,TOTAL TEXT,PRODUCTS TEXT)").then((value) {
          emit(CreateReceiptDateDatabseSuccessfullyState());
        }).catchError((error){
          emit(CreateReceiptDateDatabseErrorState());
          print(error.toString());
        });
      },
      onOpen: (db) {
        print("ReceiptData database Opened");
      },
    ).then((value) {
      receiptDatabase=value;
      print(receiptDatabase);
    });
  }


  Future insertInDateDataBase({
    required String total,
    required List<Map<String,dynamic>> products,
    required BuildContext context

  })async{
    String day = DateTime.now().day.toString();
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();
    String productsJson = jsonEncode(products);

    if(Cache_Helper.getData(key: "id").toString().isEmpty || Cache_Helper.getData(key: "id")==null){
      Cache_Helper.SetData(key: "id", value: 0);
    }
    else {
       id = Cache_Helper.getData(key: "id");
      Cache_Helper.SetData(key: "id", value: ++id);
    }

    return await receiptDatabase.transaction((txn)async{
      txn.rawInsert("INSERT INTO Receipt (ID,DAY,MONTH,YEAR,TOTAL,PRODUCTS) VALUES ('${id}' , '${day}' , '${month}' , '${year}' , '${total}', '${productsJson}')")
      .then((value){
        ProductsCubit.get(context).updateAfterSell(products: products,context: context);
        emit(InsertIntoReceiptDateDatabseSuccessfullyState());
      }).catchError((error){
        print(error);
        emit(InsertIntoReceiptDateDatabseErrorState());
      });
    });
  }

}
