import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'selles_state.dart';

class SellesCubit extends Cubit<SellesState> {
  SellesCubit() : super(SellesInitial());

  static SellesCubit get(context)=>BlocProvider.of(context);


  String statues="يومي";
  String? date;
  String month = DateTime.now().month.toString();
  String? day =DateTime.now().day.toString();
  String? year =DateTime.now().year.toString();

  void reportStatus(String status){
    if(status=="يومي"){
      final DateFormat format =DateFormat('dd/MM/yyyy');
      final String formattedDate =  format.format(DateTime.now());
      date = formattedDate;
       month=DateTime.now().month.toString();
       year=DateTime.now().year.toString();
       day = DateTime.now().day.toString();
      statues="يومي";
      emit(SellesDailyState());
    }
    else {
      month=DateTime.now().month.toString();
      year=DateTime.now().year.toString();
      day = DateTime.now().day.toString();
      statues="شهري";
      emit(SellesMonthlyState());
    }
  }

  void selectDate(DateTime datePicked){
    final DateFormat format =DateFormat('dd/MM/yyyy');
    final String formattedDate =  format.format(datePicked);
    date = formattedDate;
    month=datePicked.month.toString();
    year=datePicked.year.toString();
    day = datePicked.day.toString();
    emit(SelectDateState());
  }

  void selecctMonth(String monthPicked){
    month = monthPicked.toString();
    emit(SelectMonthState());
  }

}
