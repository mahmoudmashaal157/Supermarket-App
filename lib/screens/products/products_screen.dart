import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarkett/screens/products/cubit/products_cubit.dart';

import '../../shared/components/components.dart';

class ProductsScreen extends StatelessWidget {
  TextEditingController addInProductController = TextEditingController();
  TextEditingController subtractFromProductController = TextEditingController();
  TextEditingController updateNameController = TextEditingController();
  TextEditingController updatePriceController = TextEditingController();
  String? pressedId;
  String? pressedNum;

  @override
  Widget build(BuildContext context) {
    TextEditingController quantity = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController idController = TextEditingController();
    TextEditingController searchController = TextEditingController();
    quantity.text = "1";
    final _formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => ProductsCubit()..createDatabse(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {},
        builder: (context, state) {
          ProductsCubit cubit = ProductsCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: !cubit.showSearchBarFlag
                  ? const Text("المنتجات")
                  : TextFormField(
                      controller: searchController,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      cursorColor: Colors.white,
                      onChanged: (value) {
                        ProductsCubit.get(context)
                            .search(searchValue: searchController.text);
                      },
                    ),
              actions: [
                if (!cubit.showSearchBarFlag)
                  IconButton(
                      onPressed: () {
                        cubit.showSearchBar();
                      },
                      icon: const Icon(Icons.search)),
                if (cubit.showSearchBarFlag)
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          cubit.showSearchBar();
                          cubit.search(searchValue: "");
                          searchController.text = "";
                        },
                        icon: const Icon(Icons.cancel_outlined)),
                  ])
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columnSpacing: 10,
                              dataRowHeight: 60,
                              border: TableBorder.all(color: Colors.black38),
                              columns: [
                                const DataColumn(
                                    label: Expanded(
                                        child: Center(
                                            child: Text(
                                  "ID",
                                  style: TextStyle(color: Colors.white),
                                )))),
                                DataColumn(
                                    label: Container(
                                        width: 80,
                                        child: const Center(
                                          child: Text(
                                            "Name",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ))),
                                const DataColumn(
                                    label: Text(
                                  "QTY",
                                  style: TextStyle(color: Colors.white),
                                )),
                                const  DataColumn(
                                    label: Text(
                                  "Price",
                                  style: TextStyle(color: Colors.white),
                                )),
                                const DataColumn(
                                    label: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                )),
                                const DataColumn(
                                    label: Text(
                                  "Minus",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ],
                              rows: cubit.products
                                  .map((products) => DataRow(
                                          onLongPress: () {
                                            cubit.deleteData(
                                                id: products['id']);
                                          },
                                          cells: [
                                            DataCell(Text("${products['id']}")),
                                            DataCell(SingleChildScrollView(
                                                child: Container(
                                                  width: 120,
                                                  child: InkWell(
                                                    child: Center(
                                                     child: Text(
                                                    "${products['NAME']}",
                                                    textDirection:
                                                        TextDirection.rtl,
                                                  ),
                                              ),
                                              onTap: () {
                                                  cubit
                                                      .showUpdateNameProductDialog();
                                                  pressedId =
                                                      pressedId = products['id'];
                                              },
                                            ),
                                                ))),
                                            DataCell(
                                              Center(
                                                child: Text(
                                                  "${products['QTY']}",
                                                ),
                                              ),
                                            ),
                                            DataCell(InkWell(
                                              child: Center(
                                                child: Text(
                                                    "${products['PRICE']}"),
                                              ),
                                              onTap: () {
                                                cubit.showUpdatePriceDialog();
                                                pressedId =
                                                    pressedId = products['id'];
                                              },
                                            )),
                                            DataCell(IconButton(
                                              icon: const Icon(
                                                Icons.add_box,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                cubit.showAddProductDialog();
                                                pressedId = products['id'];
                                                pressedNum = products['QTY'];
                                              },
                                            )),
                                            DataCell(IconButton(
                                              icon: const Icon(
                                                Icons.indeterminate_check_box,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                cubit
                                                    .showSubtractProductDialog();
                                                pressedId = products['id'];
                                                pressedNum = products['QTY'];
                                              },
                                            ))
                                          ]))
                                  .toList()),
                        ),
                      ),
                    ),
                  ],
                ),
                if (state is ShowAddProductDialogState)
                  Center(child: addProductDialog(context)),
                if (state is ShowSubtractProductDialogState)
                  Center(child: subtractProductDialog(context)),
                if (state is ShowUpdateNameDialogState)
                  Center(child: updateNameDialog(context)),
                if (state is ShowUpdatePriceDialogState)
                  Center(child: updatePriceDialog(context)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 250,
                                      child: TextFormField(
                                        controller: nameController,
                                        textDirection: TextDirection.rtl,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      "الاسم",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 250,
                                      child: TextFormField(
                                        controller: priceController,
                                        textDirection: TextDirection.rtl,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      "السعر",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 250,
                                      child: TextFormField(
                                        controller: numberController,
                                        textDirection: TextDirection.rtl,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty ) {
                                            return " من فضلك ادخل الكمية ";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      "العدد",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 250,
                                      child: TextFormField(
                                        controller: idController,
                                        textDirection: TextDirection.rtl,
                                        validator: (value) {
                                          if (idController.text.isEmpty) {
                                            return "id من فضلك ادخل ";
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                        onTap: () {
                                          FlutterBarcodeScanner.scanBarcode(
                                                  "#000000",
                                                  "Cancel",
                                                  true,
                                                  ScanMode.BARCODE)
                                              .then((value) {
                                            idController.text = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      "الكود",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: ElevatedButton(
                                  child: Container(
                                    width: 250,
                                    height: 50,
                                    child: const Center(
                                      child: Text(
                                        "Add",
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      cubit.insertToDataBase(
                                          id: idController.text,
                                          name: nameController.text,
                                          price: priceController.text,
                                          qty: numberController.text);
                                      idController.text = "";
                                      nameController.text = "";
                                      priceController.text = "";
                                      numberController.text = "";
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget addProductDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Add product"),
      actions: [
        TextFormField(
          controller: addInProductController,
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
                      if(addInProductController.text.isNotEmpty){
                        ProductsCubit.get(context).addQuantity(
                            oldNumber: pressedNum.toString(),
                            newNumber: addInProductController.text,
                            id: pressedId.toString());
                      }
                      else {
                        showToast("الكميه لا يمكن ان تكون فارغه");
                        ProductsCubit.get(context).hideAddProductDialog();
                      }
                      addInProductController.text = "";
                    },
                    child: const Text("Add")),
              ),
              const Spacer(),
               Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    ProductsCubit.get(context).hideAddProductDialog();
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

  Widget subtractProductDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Subtract product"),
      actions: [
        TextFormField(
          controller: subtractFromProductController,
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
                      if(subtractFromProductController.text.isNotEmpty){
                        ProductsCubit.get(context).subtractQuantity(
                          oldNumber: pressedNum.toString(),
                          newNumber: subtractFromProductController.text,
                          id: pressedId.toString(),
                        );
                      }
                      else {
                        showToast("الكميه لا يمكن ان تكون فارغه");
                        ProductsCubit.get(context).hideSubtractProductDialog();
                      }

                      subtractFromProductController.text = "";
                    },
                    child: const Text("Subtract")),
              ),
              const Spacer(),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    ProductsCubit.get(context).hideAddProductDialog();
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

  Widget updateNameDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Name"),
      actions: [
        TextFormField(
          controller: updateNameController,
          keyboardType: TextInputType.name,
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
                      if(updateNameController.text.isNotEmpty){
                        ProductsCubit.get(context).updateName(
                            name: updateNameController.text.toString(),
                            id: pressedId.toString());
                      }
                      else {
                        showToast("الاسم لا يمكن ان يكون فارغ");
                        ProductsCubit.get(context).hideUpdateNameDialog();
                      }

                      updateNameController.text = "";
                    },
                    child: const Text("Update")),
              ),
              const Spacer(),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    ProductsCubit.get(context).hideAddProductDialog();
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

  Widget updatePriceDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Update Price"),
      actions: [
        TextFormField(
          controller: updatePriceController,
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
                      if(updatePriceController.text.isNotEmpty){
                        ProductsCubit.get(context).updatePrice(
                            price: updatePriceController.text.toString(),
                            id: pressedId.toString());
                      }
                      else {
                        showToast("السعر لا يمكن ان يكون فارغ");
                        ProductsCubit.get(context).hideUpdatePriceDialog();
                      }

                      updatePriceController.text = "";
                    },
                    child: const Text("Update")),
              ),
              const Spacer(),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    ProductsCubit.get(context).hideAddProductDialog();
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
