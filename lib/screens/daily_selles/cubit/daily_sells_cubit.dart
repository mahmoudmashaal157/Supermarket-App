import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

part 'daily_sells_state.dart';

class DailySellsCubit extends Cubit<DailySellsState> {
  DailySellsCubit() : super(DailySellsInitial());

  var database;
  List<Map<String,dynamic>>receipt=[];
  double totalSelles=0.0;

  static DailySellsCubit get(context)=> BlocProvider.of(context);

  void getTheDailySelles({
    required String day,
    required String month,
    required String year
  }){
    openDatabase(
        "ReceiptDatabase.db"
    ).then((value) {
      database=value;
      value.rawQuery("SELECT * FROM Receipt WHERE MONTH = $month AND YEAR = $year AND DAY = $day").then((value) {
        value.forEach((element) {
          String elementTotal = element['TOTAL'] as String;
          totalSelles+=double.parse(elementTotal);
            receipt.add(element);
        });
        emit(GetDailySellesSuccessfullyState());
      }).catchError((error){
        emit(GetDailySellesErrorState());
        print(error);
      });
    }).catchError((error){
    });

  }
}
