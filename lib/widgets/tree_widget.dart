import 'package:easyshop/data/Constants.dart';
import 'package:easyshop/data/Notifiers.dart';
import 'package:easyshop/pages/Home.dart';
import 'package:easyshop/pages/Products.dart';
import 'package:easyshop/pages/Profile.dart';
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
         centerTitle: true,
       ),
       bottomNavigationBar: NavigatorWidget(),
       body: ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, value, child) {
               return pages.elementAt(value);

       },),
     );
   }
}
 