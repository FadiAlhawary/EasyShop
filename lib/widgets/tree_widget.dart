import 'package:easyshop/data/Constants.dart';
import 'package:easyshop/data/Notifiers.dart';
import 'package:easyshop/pages/Cart.dart';
import 'package:easyshop/pages/Products.dart';
import 'package:easyshop/pages/WishList.dart';
import 'package:easyshop/widgets/Settings_Tree.dart';
import 'package:flutter/material.dart';

import 'Navigation_widget.dart';

 class WidgetTree extends StatefulWidget {
   const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}
List<Widget> pages =[
  Products(),
  SettingsTree(),
];
class _WidgetTreeState extends State<WidgetTree> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Easy Shop",style: KStyle.headerTextStyle,),
         centerTitle: false,
         actions: [
           IconButton(onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => Wishlist(),));
           }, icon: Icon(Icons.favorite_border)),
           IconButton(onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => Cart(),));
           }, icon: Icon(Icons.shopping_cart_outlined)),
         ],
       ),
       bottomNavigationBar: NavigatorWidget(),
       body: ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, value, child) {
               return pages.elementAt(value);

       },),
     );
   }
}
 