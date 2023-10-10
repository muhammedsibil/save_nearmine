class ProductModel {
  final String name;
  final String image;
  final dynamic totalPrice;
  final String shopName;
  final String number;
  final String weight;
  final int itemCount;
  final String weightUnit;
  const ProductModel({
    this.name = "",
    this.image = "https://picsum.photos/250?image=9",
    this.totalPrice = 0.0,
    this.shopName = "0000aaaabbbbcccc",
    this.number = "9061615995",
    this.weight = "",
    this.itemCount = 0,
    this.weightUnit: "",
  });
  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'totalPrice': totalPrice,
    'shopName': shopName,
    'number': number,
    'weight': weight,
    'itemCount': itemCount,
    'weightUnit': weightUnit,
  };
  @override
  String toString() =>
      'ProductModel(name: $name, shopName: $shopName,totalPrice: $totalPrice,number:$number)';
}
