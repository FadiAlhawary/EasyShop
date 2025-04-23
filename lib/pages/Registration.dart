import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/widgets/tree_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/constants.dart';
import '../widgets/Text_Field_Costume.dart';
import 'Log_In.dart';

class Register extends StatefulWidget {
  const Register({super.key,this.otpCode});
  final String? otpCode;
  @override
  State<Register> createState() => _RegisterState();
}
String formatTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate(); // Convert Timestamp to DateTime
  return DateFormat('dd/MM/yyyy').format(date); // Format as "day/month/year"
}
String? errorMessage;

class _RegisterState extends State<Register> {
  //----------------------------------------Controllers----------------------------------------
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
 // PhoneNumber number =
  final dateController=TextEditingController();
  String? selectedGender;
  final nameController=TextEditingController();
  //----------------------------------------Date picker----------------------------------------
  Future<void> _setDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1940),
      lastDate: DateTime(2015),
      initialDate:  DateTime(2000, 1, 1),
    );
    if (picked != null) {
      dateController.text = picked.toString().split(" ")[0];
    }
  }


  bool isLoading=false;
  double heightBetweenWidgets=10;
//----------------------------------------Name Validation----------------------------------------

  String? nameMessageError;
  bool nameFlag=false;
  String? nameValidation(String value){
    if(value.isEmpty) {
      setState(() {
        nameFlag=true;
      });
      return 'Name is empty';
    }
    nameFlag=false;
    return null;
  }
  //----------------------------------------Gender Validation----------------------------------------
   bool genderValidation(){
      if(selectedGender==null)
           return true;
      return false;
   }
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
    RegExp specailCharRegex=RegExp(r'[!@#$%^&*(),.?":{}|<>+_]');
    RegExp numbersRegex=RegExp(r'[1234567890]');
    if(value.isEmpty) {
      setState(() {
        passwordFlag=true;
      });
      return 'Password is empty';
    }
    else if(value.length<=5){
      setState(() {
        passwordFlag=true;
      });
      return 'Password Must be at least 6 characters';
    }

    else if(!specailCharRegex.hasMatch(value)){
      setState(() {
        passwordFlag=true;
      });
      return 'Password must contain at least one special character';
    }

    else if(!numbersRegex.hasMatch(value)){
      setState(() {
        passwordFlag=true;
      });
      return 'Password Must Contain at least one number';
    }
    passwordFlag=false;
    return null;
  }
  //----------------------------------------End----------------------------------------
  var verificationCode;
  @override
  Widget build(BuildContext context) {


    //----------------------------------------Sign In with email and password----------------------------------------


    Future<void> signInWithEmailAndPassword() async{
      setState(() {
        isLoading=true;
        errorMessage=null;
      });
      if(nameValidation(nameController.text.trim()) != null ||
          emailValidation(emailController.text.trim()) != null ||
          passwordValidation(passwordController.text.trim()) != null ||
           genderValidation()){
        setState(() {
          isLoading=false;

        });
        return;
      }
      try{

        final userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password:passwordController.text.trim() );

        FirebaseAuth.instance.currentUser?.reload();

            final firestore = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
            firestore.set({
              'Name' : nameController.text.trim(),
              'DOB': DateTime.parse(dateController.text.trim()),
               'Gender': selectedGender=='Male'?true :false,
               'profileImageUrl':'',
            });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(KConstants.userNameConstant, nameController.text.trim());
        await prefs.setString(KConstants.imageURLConstant,'');

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
               return WidgetTree();
        },));
      }on FirebaseAuthException catch(e){
        //print(e.message);
        setState(() {
          errorMessage=e.message;
        });
      }
      finally{
        setState(() {
          isLoading=false;
        });
      }
    }
    //----------------------------------------End----------------------------------------


    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTER'),
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
                  child: Lottie.asset('assets/lotties/register.json')),
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


              //----------------------------------------Full Name----------------------------------------

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(child: Text('Full Name', style: KStyle.headerTextStyle)),
                  TextFieldCostume(
                    hint: 'Full Name',

                    preIcon: Icon(Icons.perm_identity_rounded),
                    valueController: nameController, validationFunction: nameValidation,
                    onErrorChange: (value){
                      setState(() {
                        nameMessageError=value;
                      });
                    }, errorFlag: nameFlag, messageError: nameMessageError, isNumber: false,
                  ),
                  SizedBox(height: heightBetweenWidgets,),


                ],
              ),
              SizedBox(height: heightBetweenWidgets),
              //----------------------------------------Gender Selection----------------------------------------
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(child: Text('Gender', style: KStyle.headerTextStyle)),


                     Container(
                       padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                       border: Border.all(color:genderValidation()? Colors.red : Colors.blue,width: 1),
                          borderRadius: BorderRadius.circular(20)
                        ),
                       child: DropdownButton(
                         borderRadius: BorderRadius.circular(20),
                         isExpanded: true,
                          hint: Text('Select Gender',style: KStyle.titleTextStyle,),
                          value: selectedGender,
                          items: ['Male' , 'Female'].map((String gender) {
                              return DropdownMenuItem(
                                
                                value: gender,child: Text(gender),);
                        }).toList(),
                          onChanged: (value) {
                          setState(() {
                            selectedGender=value;
                          });
                        },),
                     ),

                ],
              ),

                 
              //----------------------------------------Date Picker----------------------------------------
              Text(
                'BirthDay',
                style: KStyle.headerTextStyle,
              ),
              SizedBox(height: heightBetweenWidgets),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  hintText: 'Enter date',
                  hintStyle: KStyle.normalTextStyle,

                  prefixIcon: Icon(Icons.date_range),
                  filled: true,
                ),
                readOnly: true,
                onTap: () {
                  _setDate();
                },
              ),
              SizedBox(height: heightBetweenWidgets),
              //----------------------------------------Submit Button----------------------------------------
              Column(

                children: [
                  if(errorMessage!=null)
                    Text(errorMessage!,style: KStyle.errorMessageTextStyle,),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : signInWithEmailAndPassword,
                      child: isLoading? CircularProgressIndicator() : Text('REGISTER', style: KStyle.normalTextStyle),
                    ),
                  ),
                ],
              ),
              SizedBox(height: heightBetweenWidgets),
              //----------------------------------------Navigation to LogIn----------------------------------------
              SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: () {
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
                    return LogIn();
                  },));
                }, child: Text('Already Have account? LogIn',style: KStyle.normalTextStyle,)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
