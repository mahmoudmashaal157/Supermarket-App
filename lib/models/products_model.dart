class ProductsModel{
  String? id;
  String? name;
  String? qty;
  String? price;
  String? total;

  ProductsModel({
    required String id,
    required String name,
    required String qty,
    required String price,
    required String total, })
  {
    this.id=id;
    this.name=name;
    this.qty=qty;
    this.price=price;
    this.total=total;
  }

  ProductsModel.fromJson(dynamic json){
    id = json['id'];
    name = json['NAME'];
    qty = json['number'].toString();
    price =json['price'].toString();
    total = json['total'].toString();
  }

  Map<String,dynamic> toMap(){
    return {
      "Id":id,
      "Name":name,
      "QTY":qty,
      "Price":price,
      "Total":total
    };
  }
}