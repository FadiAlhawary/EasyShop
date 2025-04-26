import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:easyshop/data/Notifiers.dart';
import 'package:easyshop/data/constants.dart';
import 'package:easyshop/pages/Dashboard.dart';
import 'package:easyshop/pages/Products_Uploader.dart';
import 'package:easyshop/pages/Profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Costume_List_Tile.dart';
class SettingsTree extends StatefulWidget {
  const SettingsTree({super.key});

  @override
  State<SettingsTree> createState() => _SettingsTreeState();
}

class _SettingsTreeState extends State<SettingsTree> {
  //------------------------------------------------------------Local data------------------------------------------------------------
    String userName='';
    String imageURL='';
    bool themeMode=true;
    void setData() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userNameData = prefs.getString(KConstants.userNameConstant);
      final String? imageDirc = prefs.getString(KConstants.imageURLConstant);
      final bool? repeat = prefs.getBool(KConstants.lightModeSwitchConstant);
      lightModeSwitchNotifier.value=repeat ?? false;
      setState(() {
        userName=userNameData!;
        imageDirc==null? imageURL='' : imageURL=imageDirc;
        themeMode=repeat ?? false;
      });

    }
    @override
  void initState() {
    // TODO: implement initState
     setData();
      super.initState();
  }
  double indentSize=10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
//------------------------------------------------------------Profile------------------------------------------------------------
          ProfileListTile(profileImageAsset: 'assets/images/npPerson.jpg' , title: userName, destination: Profile(), profileImageNetwork: imageURL,),
//------------------------------------------------------------Products Uploader------------------------------------------------------------
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsUploader(),));
                },
                child: SettingsListTile(listTileIcon: Icons.upload_file, title: 'Product Uploader')),

//------------------------------------------------------------DashBoard------------------------------------------------------------
 InkWell(
         onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard(),));
         },
     child: SettingsListTile(listTileIcon: Icons.dashboard, title: 'DashBoard')),
            SizedBox(
                width: double.infinity,
                child: Divider(
                  thickness: 2,
                  indent: indentSize,
                  endIndent: indentSize,
                )),

//------------------------------------------------------------Appearance------------------------------------------------------------
            InkWell(
              onTap: () {
             showDialog(context: context, builder: (context) {
                 return ValueListenableBuilder(valueListenable: lightModeSwitchNotifier, builder: (context, isLightMode, child) {
                   return AlertDialog(
                     title: Text('Theme Mode', style: KStyle.titleTextStyle),
                     content: SingleChildScrollView(
                       child: Column(
                         mainAxisSize: MainAxisSize.min,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Turn ${isLightMode ? "on" : "off"} Dark Mode', style: KStyle.normalTextStyle),
                           const SizedBox(height: 20),
                           Center(
                             child: SizedBox(
                               width: 200, // give it a nice fixed width
                               child: AnimatedToggleSwitch<bool>.dual(
                                 current: lightModeSwitchNotifier.value,
                                 first: true, // Light mode
                                 second: false, // Dark mode
                                 spacing: 50,
                                 style: ToggleStyle(
                                   borderColor: Colors.transparent,
                                   boxShadow: [
                                     BoxShadow(
                                       color: Colors.black26,
                                       spreadRadius: 1,
                                       blurRadius: 2,
                                       offset: Offset(0, 2),
                                     ),
                                   ],
                                   indicatorColor: lightModeSwitchNotifier.value ? Colors.yellow : Colors.grey[800],
                                 ),
                                 onChanged: (value) async {
                                   final SharedPreferences prefs = await SharedPreferences.getInstance();
                                   lightModeSwitchNotifier.value = value;
                                   await prefs.setBool(KConstants.lightModeSwitchConstant, value);
                                   setState(() {}); // Update the dialog
                                 },
                                 styleBuilder: (isLightMode) => ToggleStyle(
                                   indicatorColor: isLightMode ? Colors.black:Colors.yellow ,
                                 ),
                                 iconBuilder: (isLightMode) => isLightMode
                                     ? Icon(Icons.nights_stay, color: Colors.blueGrey)
                                     : Icon(Icons.wb_sunny, color: Colors.orange),
                                 textBuilder: (isLightMode) => isLightMode
                                     ? Text('Dark', style: TextStyle(color: Colors.blueGrey))
                                     : Text('Light', style: TextStyle(color: Colors.orange))
                               )

                             ),
                           ),
                         ],
                       ),
                     ),
                     actions: [
                       ElevatedButton(onPressed: () {
                         Navigator.pop(context);
                       }, child: Text('Close',style: KStyle.normalTextStyle,))
                     ],
                   );

                 },);
             },);
              },
                child: SettingsListTile(title: 'Appearance', listTileIcon: Icons.light_mode,)),
//------------------------------------------------------------Privacy------------------------------------------------------------
            SettingsListTile(title: 'Privacy', listTileIcon: Icons.lock_open_outlined,),
//------------------------------------------------------------Data and Storage------------------------------------------------------------
            SettingsListTile(title: 'Data and Storage', listTileIcon: Icons.folder_copy_outlined,),
            SizedBox(
                width: double.infinity,
                child: Divider(
                  thickness: 2,
                  indent: indentSize,
                  endIndent: indentSize,
                )),
          ],
        ),
      ),
    );
  }
}
