import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/product.dart';
import '../styles.dart';

class PromoValueCard extends StatelessWidget {
  const PromoValueCard({
    this.index,
    this.product,
    this.lastItem,
  });

  final Product product;
  final int index;
  final bool lastItem;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      //color: Colors.red,
      height: 20.0,
      width: 100,
      child: Card(child: Placeholder()),
    );

    if (lastItem) {
      return card;
    }

    return Column(
      children: <Widget>[
        card,
        Padding(
          padding: const EdgeInsets.only(
            left: 100,
            right: 16,
          ),
          child: Container(
            height: 1,
            color: Styles.productRowDivider,
          ),
        ),
      ],
    );
  }
}
