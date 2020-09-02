import 'package:flutter/foundation.dart';

enum Category {
  all,
  meat,
  fruits,
  cereal,
}

class Product {
  Product(
      {@required this.id,
      @required this.isFeatured,
      @required this.name,
      @required this.price,
      @required this.imageName,
      @required this.category})
      : assert(category != null, 'category must not be null'),
        assert(id != null, 'id must not be null'),
        assert(isFeatured != null, 'isFeatured must not be null'),
        assert(name != null, 'name must not be null'),
        assert(price != null, 'price must not be null'),
        assert(imageName != null, 'imageName must not be null');

  Category category;
  final String id;
  final bool isFeatured;
  final String name;
  final int price;
  final String imageName;

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => '$name';
}
