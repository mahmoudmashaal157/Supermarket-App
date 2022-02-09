import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:supermarkett/screens/daily_selles/daily_selles.dart';
import 'package:supermarkett/screens/sells/cubit/selles_cubit.dart';
import 'package:supermarkett/shared/components/components.dart';

import '../sells_of_year_and_month/selles_by_year_and_month.dart';

class SellesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المبيعات"),
      ),
      body: BlocProvider(
        create: (context) => SellesCubit(),
        child: BlocConsumer<SellesCubit, SellesState>(
          listener: (context, state) {},
          builder: (context, state) {
            SellesCubit cubit = SellesCubit.get(context);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    if(cubit.statues=="يومي")
                      textOfDateForDaily(context),
                    if(cubit.statues=="شهري")
                      textOfDateForMonthly(context),
                    const Spacer(),
                    Container(
                      width: 100,
                      height: 60,
                      padding: const EdgeInsets.only(right: 10),
                      child: DropdownButton(
                        value: cubit.statues,
                        icon: Icon(Icons.arrow_downward_outlined),
                        style: const TextStyle(
                            color: Colors.black, fontSize: 30),
                        underline: Container(
                          height: 2,
                          color: Colors.teal,
                        ),
                        items: <String>['شهري', 'يومي']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          cubit.reportStatus(value.toString());
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: (){
                        if(cubit.statues=="شهري"){
                          navigateTo(context, SellsByYearAndMonthScreen(cubit.year.toString(),cubit.month.toString()));
                        }
                        else if(cubit.statues=="يومي"){
                          navigateTo(context, DailySelles(cubit.year.toString(), cubit.month.toString(), cubit.day.toString()));
                        }
                      },
                      child: const Text("GO"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget textOfDateForDaily(context) {
    return InkWell(
      child: Text(
        SellesCubit.get(context).date!=null?
            "${SellesCubit.get(context).date}" :"${dateNow()}",
        style: const TextStyle(fontSize: 30),
      ),
      onTap: () {
       showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2200))
           .then((value) {
             SellesCubit.get(context).selectDate(value!);
       });
      },
    );
  }

  Widget textOfDateForMonthly(context) {
    return InkWell(
      child: Text(
        SellesCubit.get(context).month!=null?
        "${SellesCubit.get(context).month}" :"${DateTime.now().month}",
        style: const TextStyle(fontSize: 30),
      ),
      onTap: () {
        showMonthPicker(context: context, initialDate: DateTime.now()).then((value){
           String month = value!.month.toString();
          SellesCubit.get(context).selecctMonth(month);
        });
      },
    );
  }
}
