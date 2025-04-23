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
                     title: Text('Theme Mode',style: KStyle.titleTextStyle,),
                     content: ListTile(
                       leading: Text('Turn  ${isLightMode? "on" : "off"} Dark Mode',style: KStyle.normalTextStyle,),
                       title: Switch(value: !isLightMode, onChanged: (value) async {
                               lightModeSwitchNotifier.value=!lightModeSwitchNotifier.value;
                               final SharedPreferences prefs = await SharedPreferences.getInstance();
                               await prefs.setBool(KConstants.lightModeSwitchConstant, lightModeSwitchNotifier.value);

                               setState(() {
                                      isLightMode=value;
                                    });

                       },),
                     ),
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
