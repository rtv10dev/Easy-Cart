class Product {
  final String id;
  final String name;
  final String user;
  final int quantity;
  final bool checked;

  Product(this.id, this.name, this.user, this.quantity, this.checked);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        user = json['user'],
        quantity = json['quantity'],
        checked = json['checked'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'user': user,
        'quantity': quantity,
        'checked': checked
      };
}
