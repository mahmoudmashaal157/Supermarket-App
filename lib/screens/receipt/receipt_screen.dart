import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarkett/screens/checkout/checkout_screen.dart';
import 'package:supermarkett/screens/products/cubit/products_cubit.dart';
import 'package:supermarkett/screens/products/products_screen.dart';
import 'package:supermarkett/screens/products_to_expire/products_to_expire_screen.dart';
import 'package:supermarkett/screens/receipt/cubit/receipt_cubit.dart';
import 'package:supermarkett/screens/sells/selles_screen.dart';
import 'package:supermarkett/shared/components/components.dart';


class ReceiptScreen extends StatelessWidget {

  TextEditingController quantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? id;
    return BlocProvider(
      create: (context) => ReceiptCubit()..createDatabse(),
      child: BlocConsumer<ReceiptCubit, ReceiptState>(
        listener: (context, state) {},
        builder: (context, state) {
          ReceiptCubit cubit = ReceiptCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("SuperMarket"),
              actions: [
                TextButton(
                    onPressed: (){
                      cubit.emptyTheProducts();
                    },
                    child: const Text("تحديث",
                    style: TextStyle(
                      color: Colors.white
                    ),
                    )
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: [
                  Container(
                    height: 75,
                    child: const DrawerHeader(
                        decoration: BoxDecoration(
                            color: Color(0xff8E1600)
                        ),
                        child: Center(
                          child: Text("خدمات اخرى ",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    title: const Text(
                      "تقارير المبيعات",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    leading: const Icon(Icons.monetization_on_sharp),
                    onTap: () {
                      navigateTo(context, SellesScreen());
                    },
                  ),
                  const SizedBox(height: 25,),
                  ListTile(
                    title: const Text(
                      "المنتجات",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    leading: const Icon(Icons.shop_two_rounded),
                    onTap: () {
                      navigateTo(context, ProductsScreen());
                    },
                  ),
                  const SizedBox(height: 25,),
                  ListTile(
                    title:const Text(
                      "منتجات اوشكت على الانتهاء",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    leading: const Icon(Icons.indeterminate_check_box_rounded),
                    onTap: () {
                      navigateTo(context, ProductsToExpireScreen());
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                FlutterBarcodeScanner.scanBarcode(
                                    "#FF0000",
                                    "Cancel",
                                    true,
                                    ScanMode.BARCODE
                                ).then((value) {
                                  cubit.addProductToReceipt(value);
                                  print(cubit.products.length);
                                });
                              },
                              child: const Text("Scan")
                          ),
                          const SizedBox(width: 20,),
                          Text(
                            "${dateNow()}:تاريخ اليوم ",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    if(cubit.products.isEmpty)
                      const SizedBox(height: 250,),
                      if(cubit.products.isEmpty)
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              SizedBox(width: 10,),
                              Icon(
                                Icons.remove_shopping_cart,
                                size: 40,
                                color:Colors.grey,
                              ),
                              SizedBox(width: 10,),
                              Text("لا يوجد عناصر في العربه",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 30
                              ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    if(cubit.products.isNotEmpty)
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView (
                                child: DataTable(
                                  columnSpacing: 10,
                                  //dataRowHeight: 100,
                                  border: TableBorder.all(color: Colors.black38),
                                  columns: [
                                    const DataColumn(
                                        label: Text('ID')
                                    ),
                                    DataColumn(
                                        label: Container(width: 80, child: const Text("Name"))),
                                    const DataColumn(label: Text("QTY")),
                                    const DataColumn(label: Text("Price")),
                                    const DataColumn(label: Text("Total")),
                                  ],
                                  rows:cubit.products.map((products) =>
                                      DataRow(
                                        onLongPress: () {
                                          cubit.removeItemFromList(products['id'],products['number'].toString(),products["price"].toString());
                                        },
                                    cells:[
                                      DataCell(
                                          Text('${products['id']}')
                                      ),
                                      DataCell(
                                        SingleChildScrollView(
                                          child: Container(
                                            width: 80,
                                            child: Text(
                                              '${products['NAME']}',
                                              textDirection: TextDirection.rtl,),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                          InkWell(
                                            child:
                                            Center(
                                              child: Text(
                                                  "${products['number']}"
                                              ),
                                            ),
                                            onTap: () {
                                              id = products['id'];
                                              cubit.showQuantityDialog();
                                            },
                                          ),
                                      ),
                                      DataCell(
                                          Text(
                                              '${products["price"]}'
                                          ),
                                      ),
                                      DataCell(
                                          Text(
                                              '${products['total']}'
                                          ),
                                      ),
                                    ]
                                  )).toList()
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${cubit.total}",
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 20,),
                                      const Text(
                                        ":الاجمالي",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    width: 150,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        navigateTo(context, CheckoutScreen(cubit.products,cubit.total));
                                      },
                                      child: const Text("CheckOut"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if(state is ShowAddQuantityState)
                  showAddQuant(id!,context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget showAddQuant(String id,context){
    return AlertDialog(
      title: const Text("Add Quantity"),
      actions: [
        TextFormField(
          controller: quantity,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: Row(
            children: [
              Container(
                width: 100,
                child: ElevatedButton(
                    onPressed: () {
                      if(quantity.text=="0"){
                        showToast("الكميه لا يمكن ان تكون صفر");
                        ReceiptCubit.get(context).hideQuantityDialog();
                      }
                      else if (quantity.text.isEmpty){
                        showToast("الكميه لا يمكن ان تكون صفر");
                        ReceiptCubit.get(context).hideQuantityDialog();
                      }
                      else {
                        ReceiptCubit.get(context).addNewQuantity(id, quantity.text);
                      }
                      quantity.text="";
                    },
                    child:const Text("Add")),
              ),
              const Spacer(),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                   ReceiptCubit.get(context).hideQuantityDialog();
                  },
                  child: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


}
