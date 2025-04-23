import 'package:easyshop/data/Notifiers.dart';
import 'package:easyshop/data/constants.dart';
import 'package:easyshop/pages/Registration.dart';
import 'package:easyshop/widgets/tree_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure this is correctly imported
  );
  runApp(const MyApp());
}

 class MyApp extends StatefulWidget {
   const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    void initThemeMode()async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool? repeat = prefs.getBool(KConstants.lightModeSwitchConstant);
        lightModeSwitchNotifier.value=repeat ?? false;

    }
   @override
  void initState() {
    // TODO: implement initState
     initThemeMode();
    super.initState();
  }
   @override
   Widget build(BuildContext context) {

      return ValueListenableBuilder(valueListenable: lightModeSwitchNotifier, builder: (context, value, child) {
         return MaterialApp(
           theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue ,brightness: lightModeSwitchNotifier.value?  Brightness.light:  Brightness.dark)),
           debugShowCheckedModeBanner: false,
           home: StreamBuilder(stream: FirebaseAuth.instance.userChanges(), builder: (context, snapshot) {
             if(snapshot.connectionState==ConnectionState.waiting){
               return Center(child: CircularProgressIndicator(),);
             }
             if(snapshot.hasData){
               return WidgetTree();
             }
             return Register();

           },),
         );
      },);
   }
}
