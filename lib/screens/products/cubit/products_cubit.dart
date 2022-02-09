import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supermarkett/shared/components/components.dart';
import 'package:supermarkett/shared/constatnts/constatnts.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  List<Map<String,dynamic>>products=[];
  List<Map<String,dynamic>>productsAboutToExpire=[];

  List<Map<String,dynamic>>productsClone=[];
  var database;
  bool showSearchBarFlag=false;


  static ProductsCubit get (context)=>BlocProvider.of(context);

  void showAddProductDialog(){
    emit(ShowAddProductDialogState());
  }

  void hideAddProductDialog(){
    emit(HideAddProductDialogState());
  }

  void showSubtractProductDialog(){
    emit(ShowSubtractProductDialogState());
  }

  void hideSubtractProductDialog(){
    emit(HideSubtractProductDialogState());
  }

  void showUpdateNameProductDialog(){
    emit(ShowUpdateNameDialogState());
  }

  void hideUpdateNameDialog(){
    emit(HideUpdateNameDialogState());
  }

  void showUpdatePriceDialog(){
    emit(ShowUpdatePriceDialogState());
  }

  void hideUpdatePriceDialog(){
    emit(HideUpdatePriceDialogState());
  }

  void showSearchBar(){
    showSearchBarFlag = !showSearchBarFlag ;
    if(showSearchBarFlag)emit(ShowSearchBarState());
    else {emit(HideSearchBarState());}
    if(showSearchBarFlag==false){
      search(searchValue: "");
    }
  }

  void createDatabse(){
    openDatabase(
      "products.db",
    version: 1,
      onCreate: (db, version) {
        database=db;
      db.execute("CREATE TABLE products (id TEXT PRIMARY KEY,NAME TEXT,QTY TEXT,PRICE TEXT)").then((value) {
        emit(CreateDataBaseSuccessfullyState());
      }).catchError((error){
        emit(CreateDataBaseErrorState());
        print(error.toString());
      });
      },
    ).then((value) {
      database=value;
      productsDatabase=value;
      getFromDataBase(value);
      emit(OpenDataBaseSuccessfullyState());
    });
  }

  void getFromDataBase(Database database){
    products=[];
    productsClone=[];
    int i=0;
     database.rawQuery('Select * from products').then((value) {
      value.forEach((element){
        products.add(element);
        double x = double.parse(products[i]['QTY']);
        if(x<=5){
          productsAboutToExpire.add(element);
        }
        i++;
      });
      emit(GetFromDataBaseSuccessfullyState());
      allProducts=products;
      productsClone.addAll(products);
    }).catchError((error){
      emit(GetFromDataBaseErrorState());
      print(error.toString());
     });
  }

  Future insertToDataBase({
    required String id,
    required String name,
    required String price,
    required String qty,
})async
{
  return await database.transaction((txn)async {
    double qt = double.parse(qty);
    txn.rawInsert('INSERT INTO products (id,NAME,QTY,PRICE) VALUES ( "${id}","${name}","${qt}","${price}")').then((value) {
      emit(InsertIntoDataBaseSuccessfullyState());
      getFromDataBase(database);
    }).catchError((error){
      if(error is DatabaseException){
        if(error.isUniqueConstraintError()){
          showToast("المنتج موجود");
          emit(IdExistedErrorState());
        }
      }
      print("${error.toString()} ");
      emit(InsertIntoDataBaseErrorState());
    });
  });
}

  void addQuantity({
    required String oldNumber,
    required String newNumber,
    required String id,
  }){
    double newNum = double.parse(oldNumber) + double.parse(newNumber);
    _updateQTY(id: id, number: newNum.toString());
  }

  void subtractQuantity({
    required String? oldNumber,
    required String newNumber,
    required String id,
  }){
    double newNum = double.parse(oldNumber!) - double.parse(newNumber);
    if(newNum<0){
      showToast("الكميه خاطئه");
      emit(HideSubtractProductDialogState());
    }
    else
    _updateQTY(id: id, number: newNum.toString());
  }

  void _updateQTY({
  required String id,
  required String number,
}){

    database?.rawUpdate("UPDATE products SET QTY = ? WHERE id = ?",
    [number,id]).then((value) {
      emit(UpdateInDataBaseSuccessFullyState());
      getFromDataBase(database!);
    }).catchError((error){
      emit(UpdateInDataBaseErrorState());
    });
}

void updateName({required String id,required String name}){
  database?.rawUpdate("UPDATE products SET NAME = ? WHERE id = ?",
      [name,id]).then((value) {
    emit(UpdateNameSuccessfullyState());
    getFromDataBase(database!);
  }).catchError((error){
    emit(UpdateNameErrorState());
  });
}

void updatePrice({required String id,required String price}){
    database?.rawUpdate("UPDATE products SET PRICE = ? WHERE id = ?",
        [price,id]).then((value) {
      emit(UpdatePriceSuccessfullyState());
      getFromDataBase(database!);
    }).catchError((error){
      emit(UpdatePriceErrorState());
    });
  }


  void deleteData ({
    required String id,
  })
  {
    database.rawUpdate('DELETE FROM products WHERE id = ?',
      [id],).then((value){
      emit(DeleteFromDataBaseSuccessfullyState());
      getFromDataBase(database);
    }).catchError((error){
      emit(DeleteFromDataBaseErrorState());
    });
  }

  void updateAfterSell({required List<Map<String,dynamic>>products,required context}){
    openDatabase(
      "products.db",
    ).then((value) {
      database=value;
      products.forEach((element) {
        value.rawQuery("SELECT * FROM products WHERE id = ${element['id'].toString()}").then((value2){
          String? oldnum = value2[0]['QTY'] as String?;
          subtractQuantity(oldNumber: oldnum, newNumber: element['number'].toString(), id: element['id'].toString());
          emit(UpdateAfterSellSuccessfullyState());
        }).catchError((error){
          emit(UpdateAfterSellErrorState());
          print(error);
        });
      });
    }).catchError((error){
      print(error);
    });
  }


  void search ({required String searchValue}) {
    if(searchValue=="" || searchValue.isEmpty||searchValue==null||searchValue==" "){
      products=productsClone;
      emit(SearchSuccessfullyState());
    }
    products=products
        .where((string) => string['NAME'].toString().toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    emit(SearchSuccessfullyState());
  }

  }


