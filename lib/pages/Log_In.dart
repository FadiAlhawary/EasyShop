import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/widgets/tree_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/constants.dart';
import '../widgets/Text_Field_Costume.dart';
import 'Registration.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}
bool isLoading=false;
double heightBetweenWidgets=20;
class _LogInState extends State<LogIn> {
  //----------------------------------------Controllers----------------------------------------
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  //----------------------------------------Email Validation----------------------------------------

  String? emailErrorMessage;
  bool emailFlag=false;
  String? emailValidation(String value){
    if(value.isEmpty) {
      setState(() {
        emailFlag=true;
      });
      return 'Email is empty';
    }
    emailFlag=false;
    return null;
  }
//----------------------------------------PassWordValidation----------------------------------------
  String? passwordErrorMessage;
  bool passwordFlag=false;
  String? passwordValidation(String value){

    if(value.isEmpty) {
      setState(() {
        passwordFlag=true;
      });
      return 'Password is empty';
    }

    passwordFlag=false;
    return null;
  }
  //----------------------------------------Log IN USing Email and Password----------------------------------------
  Future<void> singIN()async{
    setState(() {
      errorMessage=null;
      isLoading=true;
    });
    if(emailValidation(emailController.text.trim()) != null || passwordValidation(passwordController.text.trim()) != null  ){
      setState(() {
        isLoading=false;

      });
      return;
    }
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
        final docRef = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
        final docSnapShot=await docRef.get();
        if(docSnapShot.exists){
          final data = docSnapShot.data();
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(KConstants.userNameConstant, data!['Name']);
          await prefs.setString(KConstants.imageURLConstant, data['profileImageUrl']);


        }


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return WidgetTree(); // Replace with your home screen
      }));
    }on FirebaseAuthException catch(e){
      print('error Message : ${e.message}');
      setState(() {
        errorMessage=e.message;
      });

    }finally{
      setState(() {
        isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        centerTitle: true,
        titleTextStyle: KStyle.headerTextStyle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Lottie.asset('assets/lotties/login.json')),
              Text('Email', style: KStyle.headerTextStyle),
              //----------------------------------------Email----------------------------------------
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCostume(

                    isNumber: false,
                    hint: 'Email',
                    preIcon: Icon(Icons.email_outlined),
                    valueController: emailController, validationFunction: emailValidation,
                    onErrorChange: (value){
                      setState(() {
                        emailErrorMessage=value;
                      });
                    }, errorFlag: emailFlag, messageError: emailErrorMessage,
                  ),
                  SizedBox(height: heightBetweenWidgets,),

                ],
              ),
              SizedBox(height: heightBetweenWidgets),


              //----------------------------------------Password----------------------------------------
              Text('Password', style: KStyle.headerTextStyle),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCostume(

                    isNumber: false,
                    hint: 'PassWord',
                    preIcon: Icon(Icons.lock_outline),
                    sufIconUnpressed: Icon(Icons.visibility_off_outlined),
                    sufIconPressed: Icon(Icons.visibility_outlined),
                    valueController: passwordController, validationFunction: passwordValidation, errorFlag: passwordFlag,
                    onErrorChange: (value){
                      setState(() {
                        passwordErrorMessage=value;
                      });
                    }, messageError: passwordErrorMessage,
                  ),
                  SizedBox(height: heightBetweenWidgets,),

                ],
              ),
              SizedBox(height: heightBetweenWidgets,),
              //----------------------------------------Log in button----------------------------------------
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:isLoading? null : singIN,

                  child:isLoading? CircularProgressIndicator() : Text('LOG IN', style: KStyle.normalTextStyle),
                ),
              ),
              SizedBox(height: heightBetweenWidgets),
              //----------------------------------------Navigation to LogIn----------------------------------------
              SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: () {
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
                    return Register();
                  },));
                }, child: Text('Don\'t Have An Account? Register',style: KStyle.normalTextStyle,)),
              )

            ],
          ),
        ),
      ),
    );
  }
}
