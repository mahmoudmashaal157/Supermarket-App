import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarkett/screens/checkout/cubit/checkout_cubit.dart';
import '../../shared/components/components.dart';

class CheckoutScreen extends StatelessWidget {
  List<Map<String, dynamic>> products = [];
  double price = 0.0;

  CheckoutScreen(List<Map<String, dynamic>> products, double total) {
    this.products = products;
    this.price = total;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController payedController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => CheckoutCubit()..createReceiptDateDatabse(),

      child: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {},

        builder: (context, state) {
          CheckoutCubit cubit = CheckoutCubit.get(context);

          return Form(
            key: _formKey,

            child: Scaffold(
              appBar: AppBar(
                title: Text("Checkout"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.insertInDateDataBase(
                                total: price.toString(),
                                products: products,
                                context: context);
                            showToast("تم حفظ الفاتوره بنجاح");
                            popScreen(context);
                          }
                        },
                        child: const Text(
                          "حفظ",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),

              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: DataTable(
                          //dataRowHeight: 100,
                          border: TableBorder.all(color: Colors.black38),
                          columns: [
                            const DataColumn(
                              label: Expanded(
                                  child: Text(
                                "QTY",
                                textAlign: TextAlign.center,
                              )),
                            ),
                            DataColumn(
                                label: Expanded(
                                  child: Container(
                                  width: 100,
                                   child: const Text(
                                    "Name",
                                    textAlign: TextAlign.center,
                                  )),
                            )),
                          ],
                          rows: products
                              .map((products) => DataRow(cells: [
                                    DataCell(
                                      Center(
                                        child: Text("${products['number']}"),
                                      ),
                                    ),
                                    DataCell(
                                      SingleChildScrollView(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: Text(
                                            '${products['NAME']}',
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]))
                              .toList()),
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${price}",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              ":الاجمالي",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 150,
                              height: 50,
                              child: TextFormField(
                                controller: payedController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "اين المدفوع";
                                  } else if (!cubit.checkTheRest(
                                      price, payedController.text)) {
                                    return "العمليه غير ناجحه ";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  cubit.caulateTheRest(
                                      price, payedController.text);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              ":المدفوع",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${cubit.rest}",
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              ":الباقي",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
