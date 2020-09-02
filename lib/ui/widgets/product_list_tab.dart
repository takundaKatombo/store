import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:store/model/product.dart';
import 'product_row_item.dart';

class ProductListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = Firestore.instance.collection('products');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return ProductRowItem(
              //index: index,
              product: new Product(
                  name: document.data["name"],
                  id: document.documentID,
                  category: Category.all,
                  isFeatured: document.data["isFeatured"],
                  price: document.data["price"].toInt(),
                  imageName: document.data['imageName']),
              lastItem: false,
            );
          }).toList(),
        );
      },
    );
  }
}
