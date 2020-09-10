//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store/model/app_state_model.dart';
import 'package:store/model/product.dart';
import 'package:store/ui/styles.dart';

//const double _kDateTimePickerHeight = 216;

class ShoppingCartTab extends StatefulWidget {
  @override
  _ShoppingCartTabState createState() {
    return _ShoppingCartTabState();
  }
}

class _ShoppingCartTabState extends State<ShoppingCartTab> {
  String name;
  String email;
  Map<String, String> location;
  String surbub;
  String street;
  String city;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final streetController = TextEditingController();
  final surbubController = TextEditingController();
  final cityController = TextEditingController();

  DateTime dateTime = DateTime.now();
  final _currencyFormat = NumberFormat.currency(symbol: '\$');
  final _formKey = GlobalKey<FormState>();

  Widget _buildEmailField() {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: ListTile(
            title: Text('Payments'),
            subtitle: Text('Add method'),
            trailing: IconButton(icon: Icon(Icons.payment), onPressed: null),
          ),
        ));
  }

  // Widget _buildLocationField() {
  //   return const CupertinoTextField(
  //     prefix: Icon(
  //       CupertinoIcons.location_solid,
  //       color: CupertinoColors.lightBackgroundGray,
  //       size: 28,
  //     ),
  //     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
  //     clearButtonMode: OverlayVisibilityMode.editing,
  //     textCapitalization: TextCapitalization.words,
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: BorderSide(
  //           width: 0,
  //           color: CupertinoColors.inactiveGray,
  //         ),
  //       ),
  //     ),
  //     placeholder: 'Delivery Address',
  //   );
  // }

  // Widget _buildDateAndTimePicker(BuildContext context) {
  //   return Column(
  //     children: <Widget>[
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: const <Widget>[
  //               Icon(
  //                 CupertinoIcons.clock,
  //                 color: CupertinoColors.lightBackgroundGray,
  //                 size: 28,
  //               ),
  //               SizedBox(width: 6),
  //               Text(
  //                 'Delivery date',
  //                 style: Styles.deliveryTimeLabel,
  //               ),
  //             ],
  //           ),
  //           Text(
  //             DateFormat.yMMMd().add_jm().format(dateTime),
  //             style: Styles.deliveryTime,
  //           ),
  //         ],
  //       ),
  //       Container(
  //         height: _kDateTimePickerHeight,
  //         child: CupertinoDatePicker(
  //           mode: CupertinoDatePickerMode.dateAndTime,
  //           initialDateTime: dateTime,
  //           onDateTimeChanged: (newDateTime) {
  //             setState(() {
  //               dateTime = newDateTime;
  //             });
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  SliverChildBuilderDelegate _buildSliverChildBuilderDelegate(
      AppStateModel model) {
    return SliverChildBuilderDelegate(
      (context, index) {
        final productIndex = index;
        switch (index) {
          default:
            if (model.productsInCart.length > productIndex) {
              return ShoppingCartItem(
                index: index,
                product: model.getProductById(
                    model.productsInCart.keys.toList()[productIndex]),
                quantity: model.productsInCart.values.toList()[productIndex],
                lastItem: productIndex == model.productsInCart.length - 1,
                formatter: _currencyFormat,
              );
            } else if (model.productsInCart.keys.length == productIndex &&
                model.productsInCart.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Shipping '
                          '${_currencyFormat.format(model.shippingCost)}',
                          style: Styles.productRowItemPrice,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tax ${_currencyFormat.format(model.tax)}',
                          style: Styles.productRowItemPrice,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Total  ${_currencyFormat.format(model.totalCost)}',
                          style: Styles.productRowTotal,
                        ),
                        RaisedButton(
                          // onPressed: () {
                          //   showGeneralDialog(
                          //       context: context,
                          //       barrierDismissible: true,
                          //       barrierLabel: MaterialLocalizations.of(context)
                          //           .modalBarrierDismissLabel,
                          //       barrierColor: Colors.black45,
                          //       transitionDuration:
                          //           const Duration(milliseconds: 200),
                          //       pageBuilder: (BuildContext buildContext,
                          //           Animation animation,
                          //           Animation secondaryAnimation) {
                          //         return Center(
                          //           child: Container(
                          //             width: MediaQuery.of(context).size.width -
                          //                 10,
                          //             height:
                          //                 MediaQuery.of(context).size.height -
                          //                     80,
                          //             padding: EdgeInsets.all(20),
                          //             color: Colors.white,
                          //             child: Column(
                          //               children: [
                          //                 _buildNameField(),
                          //                 _buildEmailField(),
                          //                 //_buildLocationField(),
                          //                 //_buildDateAndTimePicker(context),
                          //                 RaisedButton(
                          //                   onPressed: () {
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                   child: Text(
                          //                     "Submit Order",
                          //                     style: TextStyle(
                          //                         color: Colors.white),
                          //                   ),
                          //                   color: Colors.red,
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       });

                          // },
                          onPressed: () {
                            if (model.productsInCart.isNotEmpty)
                              Firestore.instance.collection("orders").add({
                                'cart': model.productsInCart,
                                'name': name,
                                'email': email,
                                'street': street,
                                'city': city,
                                'surbub': surbub
                              });
                            model.clearCart();
                          },
                          child: Text('Checkout'),
                        )
                      ],
                    )
                  ],
                ),
              );
            }
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              const CupertinoSliverNavigationBar(
                actionsForegroundColor: Colors.red,
                largeTitle: Text('Shopping Cart'),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 250,
                  child: ListView(
                    //scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          buildShowGeneralDialog(context, model);

                          // Firestore.instance
                          //     .collection("orders")
                          //     .add({'map': model.productsInCart});
                          // model.clearCart();
                        },
                        child: Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: ListTile(
                                title: name != null
                                    ? Text(name)
                                    : Text(
                                        'Delivery info (address and contact)'),
                                subtitle: name != null
                                    ? Text(street + ' ' + surbub + ' ' + city)
                                    : Text('Add info'),
                                trailing: IconButton(
                                    icon: Icon(Icons.add_location),
                                    onPressed: null),
                              ),
                            )
                            // Card(
                            //   child: Text('Delivery info (address and contact)'),
                            // ),
                            ),
                      ),
                      _buildEmailField(),
                      //_buildLocationField(),
                      //_buildDateAndTimePicker(context)
                    ],
                  ),
                ),
              ),
              SliverSafeArea(
                top: false,
                minimum: const EdgeInsets.only(top: 4),
                sliver: SliverList(
                  delegate: _buildSliverChildBuilderDelegate(model),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future buildShowGeneralDialog(BuildContext context, AppStateModel model) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Stack(children: [
            Positioned(
                top: 0,
                left: 0,
                height: MediaQuery.of(context).size.height * 0.65,
                child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      child: Form(
                          child: ListView(
                        children: [
                          TextFormField(
                            //onChanged: (value) => ,
                            controller: nameController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            validator: (value) =>
                                value.isEmpty ? 'Name can\'t be empty' : null,
                            onFieldSubmitted: (value) => name = value.trim(),
                            cursorColor: Colors.red,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              //border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          TextFormField(
                            //onChanged: (value) => ,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            validator: (value) =>
                                value.isEmpty ? 'Email can\'t be empty' : null,
                            onFieldSubmitted: (value) => email = value.trim(),
                            cursorColor: Colors.red,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              hintText: 'Enter your email',
                              //border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          TextFormField(
                            //onChanged: (value) => ,
                            controller: streetController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            validator: (value) =>
                                value.isEmpty ? 'street can\'t be empty' : null,
                            onFieldSubmitted: (value) => street = value.trim(),
                            cursorColor: Colors.red,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              hintText: 'street eg. 34 ascot road',
                              //border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          TextFormField(
                            //onChanged: (value) => ,
                            controller: surbubController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            validator: (value) => value.isEmpty
                                ? 'Surburb can\'t be empty'
                                : null,
                            onFieldSubmitted: (value) => surbub = value.trim(),
                            cursorColor: Colors.red,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              hintText: 'Surburb eg. North Riding',
                              //border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          TextFormField(
                            //onChanged: (value) => ,
                            controller: cityController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            validator: (value) =>
                                value.isEmpty ? 'City can\'t be empty' : null,
                            onFieldSubmitted: (value) => city = value.trim(),
                            cursorColor: Colors.red,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                              hintText: 'City eg. Jhb',
                              //border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          RaisedButton(onPressed: () {
                            name = nameController.text;
                            email = emailController.text;
                            city = cityController.text;
                            surbub = surbubController.text;
                            street = streetController.text;
                            setState(() {});

                            print(name);
                            print(street);
                            print(surbub);
                            print(city);
                            print(email);
                            setState(() {
                              //model.address = location;
                            });
                          })
                        ],
                      )),
                    )
                    // Column(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: <Widget>[
                    //     Container(
                    //       padding: EdgeInsets.all(8),
                    //       child: Container(
                    //         width: 60,
                    //         height: 6,
                    //         decoration: BoxDecoration(
                    //           color: Colors.grey,
                    //           borderRadius:
                    //               BorderRadius.circular(2),
                    //         ),
                    //       ),
                    //     ),
                    //     // title != ''
                    //     //     ? Text(title, style: _theme.textTheme.display1)
                    //     //     : Container(),
                    //     // Padding(
                    //     //   padding: EdgeInsets.only(bottom: 8),
                    //     // ),
                    //     // //child
                    //   ],
                    // ),
                    )),
          ]);
        });
  }
}

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({
    @required this.index,
    @required this.product,
    @required this.lastItem,
    @required this.quantity,
    @required this.formatter,
  });

  final Product product;
  final int index;
  final bool lastItem;
  final int quantity;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
          right: 8,
        ),
        child: Card(
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  product.imageName,
                  width: 76,
                  height: 90,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            product.name,
                            style: Styles.productRowItemName,
                          ),
                          Text(
                            '${formatter.format(quantity * product.price)}',
                            style: Styles.productRowItemName,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${quantity > 1 ? '$quantity x ' : ''}'
                        '${formatter.format(product.price)}',
                        style: Styles.productRowItemPrice,
                      )
                    ],
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  final model = Provider.of<AppStateModel>(context);
                  model.removeItemFromCart(product.id);
                },
                child: const Icon(
                  CupertinoIcons.minus_circled,
                  semanticLabel: 'Remove',
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return row;
  }
}
