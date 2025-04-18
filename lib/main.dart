import 'package:easyshop/pages/Registration.dart';
import 'package:easyshop/widgets/tree_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure this is correctly imported
  );
  runApp(const MyApp());
}

 class MyApp extends StatelessWidget {
   const MyApp({super.key});

   @override
   Widget build(BuildContext context) {
     return MaterialApp(

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
   }
 }
