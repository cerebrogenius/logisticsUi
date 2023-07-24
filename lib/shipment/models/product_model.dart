class Product {
  String title;
  String productId;
  String destination;
  String source;
  double price;
  String status;
  bool onTheWay;

  Product({
    required this.status,
    required this.title,
    required this.productId,
    required this.destination,
    required this.source,
    required this.price,
    required this.onTheWay
  });
}