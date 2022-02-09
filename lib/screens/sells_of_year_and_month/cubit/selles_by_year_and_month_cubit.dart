import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

part 'selles_by_year_and_month_state.dart';

class SellesByYearAndMonthCubit extends Cubit<SellesByYearAndMonthState> {
  SellesByYearAndMonthCubit() : super(SellesByYearAndMonthInitial());

  static SellesByYearAndMonthCubit get(context)=>BlocProvider.of(context);
  var database;
  List<Map<String,dynamic>>receipt=[];
  late String _day;
  Map<String,bool>existed={};
  double totalSells =0.0;

  void getTheMonthlySelles({
    required String month,
    required String year
  }){
    openDatabase(
      "ReceiptDatabase.db"
    ).then((value) {
      database=value;
      value.rawQuery("SELECT * FROM Receipt WHERE MONTH = $month AND YEAR = $year").then((value) {
        value.forEach((element) {
          List<String>listofdate=[element['DAY'].toString(),element['MONTH'].toString(),element['YEAR'].toString()];
          _day = listofdate.join();
          String elementTotal = element["TOTAL"] as String;
          totalSells = totalSells + double.parse(elementTotal);
          if(existed[_day]==null){
            existed[_day]=true;
            receipt.add(element);
          }
        });
        print(totalSells);
        emit(GetMonthlySellesSuccessfullyState());
      }).catchError((error){
        emit(GetMonthlySellesErrorState());
        print(error);
      });
    }).catchError((error){
    });

  }

}
