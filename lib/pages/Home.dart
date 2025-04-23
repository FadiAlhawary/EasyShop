import 'package:easyshop/pages/Cart.dart';
import 'package:easyshop/pages/Category.dart';
import 'package:easyshop/pages/Dashboard.dart';
import 'package:easyshop/pages/Order.dart';
import 'package:easyshop/pages/Products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Cart.dart';
import 'ProductView.dart';
import 'WishList.dart';
 
  class Home extends StatelessWidget {
    const Home({super.key});
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Products();
                },));
              }, child: Text('Products')),

              FilledButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Cart();
                },));
              }, child: Text('carts')),

              FilledButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Wishlist();
                },));
              }, child: Text('WishList')),

              FilledButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Order();
                },));
              }, child: Text('Order')),

              // FilledButton(onPressed: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     return Cat();
              //   },));
              // }, child: Text('Category')),

              FilledButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Dashboard();
                },));
              }, child: Text('Dashboard')),


              FilledButton(onPressed: () {
                FirebaseAuth.instance.signOut();
              }, child: Text('Log out')),
            ],
          ),
        ),
      );
    }
  }
  