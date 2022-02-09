import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/details_of_daily_receipt_cubit.dart';

class DetailsOfDailyReceipts extends StatelessWidget {
  late String id;

  DetailsOfDailyReceipts(String id) {
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DetailsOfDailyReceiptCubit()..getTheMonthlySelles(id: id),
      child: BlocConsumer<DetailsOfDailyReceiptCubit, DetailsOfDailyReceiptState>(

        listener: (context, state) {},
        builder: (context, state) {
          DetailsOfDailyReceiptCubit cubit =
              DetailsOfDailyReceiptCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text("id: $id"),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                        columnSpacing: 10,
                        border: TableBorder.all(color: Colors.black38),
                        columns: [
                          const DataColumn(label: Text('ID')),
                          DataColumn(label:  Container(width: 80, child:const Text("Name"))),
                          const DataColumn(label: Text("QTY")),
                          const DataColumn(label: Text("Price")),
                          const DataColumn(label: Text("Total")),
                        ],
                        rows: cubit.productDetails
                            .map((products) => DataRow(cells: [
                                  DataCell(Text('${products.id}')),
                                  DataCell(
                                    SingleChildScrollView(
                                      child: Text(
                                        '${products.name}',
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text("${products.qty}"),
                                  ),
                                  DataCell(
                                    Text('${products.price}'),
                                  ),
                                  DataCell(
                                    Text('${products.total}'),
                                  ),
                                ]))
                            .toList()),
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: state is GetReceiptDetailsSuccessfullyState
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${cubit.products[0]["TOTAL"]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            const Padding(
                              padding:  EdgeInsets.only(right: 8.0),
                              child: Text(
                                " :الاجمالي",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
