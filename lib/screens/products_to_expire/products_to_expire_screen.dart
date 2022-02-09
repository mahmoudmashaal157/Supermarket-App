import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarkett/screens/products/cubit/products_cubit.dart';

class ProductsToExpireScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TextEditingController quantity = TextEditingController();
    quantity.text = "1";
    return BlocProvider(
      create: (context) => ProductsCubit()..createDatabse(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {},
        builder: (context, state) {
          ProductsCubit cubit = ProductsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              title: Text("منتجات اوشكت على الانتهاء"),
            ),
            body: Column(
              children: [
                if(cubit.productsAboutToExpire.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 30,
                        dataRowHeight: 60,
                        border: TableBorder.all(color: Colors.black38),
                        columns: [
                          const DataColumn(label: Text("ID")),
                          DataColumn(
                              label: Container(width: 80, child: const Text("Name"))),
                          const DataColumn(label: Text("QTY")),
                          const DataColumn(label: Text("Price")),

                        ],
                          rows: cubit.productsAboutToExpire.map((products) => DataRow(
                              cells: [
                                DataCell(Text("${products['id']}")),
                                DataCell(
                                    SingleChildScrollView(
                                        child: Container(
                                          width: 120,
                                          child: Text(
                                            "${products['NAME']}"
                                            ,textDirection: TextDirection.rtl,),
                                        )
                                    ),
                                ),
                                DataCell(Text("${products['QTY']}")),
                                DataCell(Text("${products['PRICE']}")),
                              ]
                          )).toList()
                      ),
                    ),
                  ),
                ),
                if(cubit.productsAboutToExpire.isEmpty)
                  const SizedBox(height: 150,),
                if(cubit.productsAboutToExpire.isEmpty)
                   Center(
                    child: Column(

                      children: [
                        Image.asset("assets/images/smile-emoji-new.png",
                        scale:2 ,
                        ),
                        const SizedBox(height: 20,),
                        const Text("لا يوجد منتجات اوشكت على الانتهاء",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold
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
}
