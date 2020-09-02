import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'product.dart';
import 'products_repository.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends foundation.ChangeNotifier {
  // All the available products.
  List<Product> availableProducts = [];

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  final _productsInCart = <String, int>{};

  var db = Firestore.instance.collection('products');

  Stream<QuerySnapshot> availableProductsStream = Firestore.instance
      .collection('products')
      .snapshots()
      .asBroadcastStream(); //todo change product id to string

  Map<String, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  // Total number of items in the cart.
  int get totalCartQuantity {
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }

  Category get selectedCategory {
    return _selectedCategory;
  }

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      // Extended price for product line
      return getProductById(id).price * _productsInCart[id];
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (accumulator, itemCount) {
          return accumulator + itemCount;
        });
  }

  // Sales tax for the items in the cart
  double get tax {
    return subtotalCost * _salesTaxRate;
  }

  // Total cost to order everything in the cart.
  double get totalCost {
    return subtotalCost + shippingCost + tax;
  }

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (availableProducts == null) {
      return [];
    }

    if (_selectedCategory == Category.all) {
      return List.from(availableProducts);
    } else {
      return availableProducts.where((p) {
        return p.category == _selectedCategory;
      }).toList();
    }
  }

  // Search the product catalog
  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  // Adds a product to the cart.
  void addProductToCart(String productId) {
    print('in add product to cart');
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
      print('if is true');
    } else {
      print('else is true');
      _productsInCart[productId]++;
    }
    print(_productsInCart);
    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(String productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Stream<Product> getProductsInCart() {
    //print(availableProductsStream);
    Iterable<String> cart = productsInCart.keys;
    StreamController<Product> controller = StreamController<Product>();
    Stream<Product> cartStream = controller.stream.asBroadcastStream();
    cart.forEach((id) {
      availableProducts.where((element) => element.id == id).forEach((product) {
        controller.sink.add(product);
        //print('Document exists on the database');
      });
    });
    return cartStream;
  }

  List getCartList() {
    //print(availableProductsStream);
    Iterable<String> cart = productsInCart.keys;
    StreamController<Product> controller = StreamController<Product>();
    Stream<Product> cartStream = controller.stream.asBroadcastStream();
    cart.forEach((id) {
      availableProducts.where((element) => element.id == id).forEach((product) {
        controller.sink.add(product);
        //print('Document exists on the database');
      });
    });
    return cartStream as List;
  }

  Product getProductById(String id) {
    return availableProducts.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() async {
    //    await Firestore.instance.collection('products').snapshots();
    availableProductsStream.listen((QuerySnapshot querySnapshot) => {
          querySnapshot.documents.forEach((document) {
            Product newProduct = new Product(
                id: document.documentID,
                isFeatured: document.data['isFeatured'],
                name: document.data['name'],
                price: document.data['price'].toInt(),
                category: Category.all,
                imageName: document.data['imageName']);

            availableProducts.add(newProduct);
          })
        });

    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
