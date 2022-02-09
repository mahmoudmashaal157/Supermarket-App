import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarkett/screens/daily_selles/daily_selles.dart';
import 'package:supermarkett/shared/components/components.dart';

import 'cubit/selles_by_year_and_month_cubit.dart';

class SellsByYearAndMonthScreen extends StatelessWidget {
  late String month;
  late String year;

  SellsByYearAndMonthScreen(String year, String month) {
    this.month = month;
    this.year = year;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SellesByYearAndMonthCubit()..getTheMonthlySelles(month: month, year: year),
      child: BlocConsumer<SellesByYearAndMonthCubit, SellesByYearAndMonthState>(
        listener: (context, state) {},
        builder: (context, state) {
          SellesByYearAndMonthCubit cubit = SellesByYearAndMonthCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text("$month/$year"),
            ),
            body: Column(
              children: [
                if(cubit.receipt.isNotEmpty)
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return dayItem(index, cubit.receipt,context);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20,);
                      },
                      itemCount: cubit.receipt.length
                  ),
                ),
                Container(
                  width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text("اجمالي المبيعات",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text("${cubit.totalSells}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget dayItem(int index,List<Map<String,dynamic>>receipts,context){
    return InkWell(
      child: Card(
        child: Container(
          height: 70,
        color: Colors.grey[300],
          child: Center(
            child: Text(" ${receipts[index]['DAY']}/${receipts[index]['MONTH']}/${receipts[index]['YEAR']}",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
            ),
          ),
        ),
      ),
      onTap: () {
        navigateTo(context, DailySelles(receipts[index]['YEAR'], receipts[index]['MONTH'], receipts[index]['DAY']));
      },
    );

  }
}
