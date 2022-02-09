import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  ReceiptCubit() : super(ReceiptInitial());

  var products =<Map<String,dynamic>>[];
  List<Map<String,dynamic>>selectedProducts=[];
  Map<String,bool>existed={};
  var database;
  int index=0;
  double total=0;

  static ReceiptCubit get(context)=> BlocProvider.of(context);

  void createDatabse(){
    openDatabase(
      "products.db",
      version: 1,
      onCreate: (db, version) {
        database=db;
        print("databaseCreated");
        db.execute("CREATE TABLE products (id TEXT PRIMARY KEY,NAME TEXT,QTY TEXT,PRICE TEXT)").then((value) {
          emit(CreateDataBaseSuccessfullyState());
        }).catchError((error){
          emit(CreateDataBaseErrorState());
          print(error.toString());
        });
      },
    ).then((value) {
      database=value;
      getFromDataBase(value);
      emit(OpenDataBaseSuccessfullyState());
    });
  }

  void getFromDataBase(Database database){
    selectedProducts=[];
    database.rawQuery('Select * from products').then((value) {
      value.forEach((element){
        selectedProducts.add(element);
      });
      emit(GetFromDataBaseSuccessfullyState());
    }).catchError((error){
      emit(GetFromDataBaseErrorState());
      print(error.toString());
    });
  }

  void addProductToReceipt(String barCode){
    database.rawQuery('Select * from products WHERE id = ? ',[barCode]).then((value) {
      value.forEach((element){
        if(existed[element['id']]==true){
          addQuantity(element['id']);
        }
        else {
          existed[element['id']]=true;
          products.add({
            'NAME':element['NAME'].toString(),
            'number':1,
            'id':element['id'].toString(),
            'price':double.parse(element['PRICE']),
            'total': element['PRICE'],
          }) ;
          total+=double.parse(element['PRICE']);
          index++;
        }
      });
      emit(AddProductToReceipt());
    }).catchError((error){
      emit(GetFromDataBaseErrorState());
      print(error.toString());
    });
  }

  void addQuantity(String barCode){
    for(int i=0;i<products.length;i++){
      print(" $barCode   ssss   ${products[i]['id']} ");
      if(barCode==products[i]['id']){
        products[i]['number']++;
        double x = (products[i]['price'] * products[i]['number']);
        products[i]['total']= x.toString();
        total += products[i]['price'];
      }
      emit(CalculateTheTotalOfOneProduct());
    }
  }

  void showQuantityDialog(){
    emit(ShowAddQuantityState());
  }

  void hideQuantityDialog(){
    emit(HideAddQuantityState());
  }

  void addNewQuantity(String barCode , String quan){
    for(int i=0;i<products.length;i++){
      if(barCode==products[i]['id']){
        products[i]['number'] = double.parse(quan);
        total -= double.parse(products[i]['total']);
        double x = (products[i]['price'] * products[i]['number']);
        products[i]['total'] = x.toString();
        total+=x;
      }
      emit(CalculateTheTotalOfOneProduct());
    }
  }

  void removeItemFromList(String barCode,String number,String price){
    products.removeWhere((element) => element['id']==barCode);
    existed.remove(barCode);
    double subtractedTotal = double.parse(number)*double.parse(price);
    double newTotal = total - subtractedTotal;
    total = newTotal;
    emit(RemoveItemFromListState());
  }

  void emptyTheProducts(){
    products.clear();
    existed.clear();
    total=0.0;
    selectedProducts.clear();
    emit(EmptyTheListState());
  }




}
