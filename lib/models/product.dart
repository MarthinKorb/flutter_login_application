import 'dart:convert';

class Product {
  final String id;
  final String description;
  final String idUser;
  Product({
    this.id,
    this.description,
    this.idUser,
  });

  Product copyWith({
    String id,
    String description,
    String idUser,
  }) {
    return Product(
      id: id ?? this.id,
      description: description ?? this.description,
      idUser: idUser ?? this.idUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'idUser': idUser,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Product(
      id: map['id'],
      description: map['description'],
      idUser: map['idUser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() =>
      'Product(id: $id, description: $description, idUser: $idUser)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Product &&
        o.id == id &&
        o.description == description &&
        o.idUser == idUser;
  }

  @override
  int get hashCode => id.hashCode ^ description.hashCode ^ idUser.hashCode;
}
