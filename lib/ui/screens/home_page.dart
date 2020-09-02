import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:store/model/app_state_model.dart';
import 'package:store/model/product.dart';
import 'package:store/ui/widgets/product_row_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Colors.red,
        //leading: IconButton(icon: Icon(Icons.tune), onPressed: null),
        //title: Text('Eilandtzicht'),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Search', style: TextStyle(color: Colors.red)),
            icon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(),
                    ),
                color: Colors.red),
          ),
          BottomNavigationBarItem(
            title: Text('Checkout', style: TextStyle(color: Colors.red)),
            icon: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, '/shopping_cart_tab'),
              color: Colors.red,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Account',
              style: TextStyle(color: Colors.red),
            ),
            icon: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: null,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Stack(children: [
        CollapsingList(),
      ]),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CollapsingList extends StatefulWidget {
  @override
  _CollapsingListState createState() => _CollapsingListState();
}

class _CollapsingListState extends State<CollapsingList> {
  @override
  Widget build(BuildContext context) {
    //CollectionReference users = Firestore.instance.collection('products');
    return Consumer<AppStateModel>(builder: (context, model, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: model.availableProductsStream,
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
                    id: document.documentID,
                    isFeatured: document.data['isFeatured'],
                    name: document.data['name'],
                    price: document.data['price'].toInt(),
                    category: Category.all,
                    imageName: document.data['imageName']),
                lastItem: false,
              );
            }).toList(),
          );
        },
      );
    });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final results = model.search(query);

    return ListView.builder(
      itemBuilder: (context, index) => ProductRowItem(
        index: index,
        product: results[index],
        lastItem: index == results.length - 1,
      ),
      itemCount: results.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
