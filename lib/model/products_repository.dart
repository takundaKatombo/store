import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/model/app_state_model.dart';
import 'package:store/services/locator.dart';

import 'product.dart';

class ProductsRepository {
  static var addToProducts = locator<AppStateModel>();

  var _products = Firestore.instance
      .collection('users')
      .snapshots()
      .listen((QuerySnapshot querySnapshot) => {
            querySnapshot.documents.forEach((document) {
              Product newProduct = new Product(
                  id: document.documentID,
                  isFeatured: document.data['isFeatured'],
                  name: document.data['name'],
                  price: document.data['price'].toInt(),
                  category: Category.all,
                  imageName: document.data['imageName']);

              addToProducts.availableProducts.add(newProduct);
            })
          });

  get products => _products;

  set products(products) {
    _products = products;
  }
}
