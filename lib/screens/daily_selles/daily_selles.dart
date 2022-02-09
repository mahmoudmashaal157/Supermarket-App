import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarkett/screens/daily_selles/cubit/daily_sells_cubit.dart';
import 'package:supermarkett/screens/details_of_daily_receipts/details_of_daily_receipts.dart';
import 'package:supermarkett/shared/components/components.dart';

class DailySelles extends StatelessWidget {
  late String month;
  late String year;
  late String day;

  DailySelles(String year, String month, String day) {
    this.month = month;
    this.year = year;
    this.day = day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailySellsCubit()..getTheDailySelles(day: day, month: month, year: year),

      child: BlocConsumer<DailySellsCubit, DailySellsState>(
        listener: (context, state) {},
        builder: (context, state) {
          DailySellsCubit cubit = DailySellsCubit.get(context);
          return Scaffold(

            appBar: AppBar(
              title: Text("$day/$month/$year"),
            ),

            body: Column(
              children: [
                Expanded(
                  child:
                  ListView.separated(
                      itemBuilder: (context, index) {
                        return dayItem(index, cubit.receipt,context);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 20,);
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
                        child: Text("${cubit.totalSelles}",
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

  Widget dayItem(int index, List<Map<String, dynamic>>receipts,context) {
    return InkWell(
      child: Card(
        child: Container(
          height: 70,
          color: Colors.grey[300],
          child: Center(
            child: Text("ID =  ${receipts[index]['ID']}",
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        navigateTo(context, DetailsOfDailyReceipts(receipts[index]['ID'].toString()));
      },
    );
  }

}
