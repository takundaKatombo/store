import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/model/app_state_model.dart';
import 'package:store/model/product.dart';
import 'package:store/ui/styles.dart';
import 'package:store/ui/widgets/product_row_item.dart';
import 'package:store/ui/widgets/search_bar.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _terms = _controller.text;
    });
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    //final results = model.search(_terms);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Search '),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Styles.scaffoldBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBox(),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('products')
                    .where('name', arrayContains: _terms)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      Product newProduct = new Product(
                          id: document.documentID,
                          isFeatured: document.data['isFeatured'],
                          name: document.data['name'],
                          price: document.data['price'].toInt(),
                          category: Category.all,
                          imageName: document.data['imageName']);

                      //addToProducts.loadProducts(newProduct);
                      return ProductRowItem(
                        //index: index,
                        product: newProduct,
                        lastItem: false,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
