import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store/model/enums.dart';
import 'package:store/model/login_model.dart';
import 'package:store/services/locator.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final LogInModel loginCallback = locator<LogInModel>();

  var emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const CupertinoSliverNavigationBar(
            actionsForegroundColor: Colors.red,
            largeTitle: Text('My Account'),
          ),
          SliverToBoxAdapter(
            child: loginCallback.loginStatus == AuthStatus.NOT_LOGGED_IN
                ? showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),
                    pageBuilder: (BuildContext buildContext,
                        Animation animation, Animation secondaryAnimation) {
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
                                        obscureText: true,
                                        //onChanged: (value) => ,
                                        controller: passwordController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        autofocus: true,
                                        validator: (value) => value.isEmpty
                                            ? 'Name can\'t be empty'
                                            : null,
                                        // onFieldSubmitted: (value) =>
                                        //     name = value.trim(),
                                        cursorColor: Colors.red,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your name',
                                          //border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        //onChanged: (value) => ,
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        autofocus: true,
                                        validator: (value) => value.isEmpty
                                            ? 'Email can\'t be empty'
                                            : null,
                                        // onFieldSubmitted: (value) =>
                                        //     email = value.trim(),
                                        cursorColor: Colors.red,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your email',
                                          //border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red),),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      RaisedButton(onPressed: () {
                                        loginCallback.signupCallBack(
                                            emailController.text,
                                            passwordController.text);
                                        setState(() {});
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
                    })
                : Container(
                    height: 250,
                    child: ListView(
                      //scrollDirection: Axis.horizontal,
                      children: [
                        ListTile(
                          title: Text('Delivery Address '),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Payment Methods'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Promo Codes'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
          ),
          // SliverSafeArea(
          //   top: false,
          //   minimum: const EdgeInsets.only(top: 4),
          //   sliver: SliverList(
          //     delegate: _buildSliverChildBuilderDelegate(model),
          //   ),
          // )
        ],
      ),
    );
  }
}
