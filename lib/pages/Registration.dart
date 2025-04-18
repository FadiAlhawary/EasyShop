import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firechat/pages/Log_In.dart';
//import 'package:firechat/pages/otp_Verify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottie/lottie.dart';

import '../data/constants.dart';
import 'Log_In.dart';

class Register extends StatefulWidget {
  const Register({super.key,this.otpCode});
  final String? otpCode;
  @override
  State<Register> createState() => _RegisterState();
}
String? errorMessage;
class _RegisterState extends State<Register> {
  //----------------------------------------Controllers----------------------------------------
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
 // PhoneNumber number = PhoneNumber(isoCode: 'US');
  //----------------------------------------End----------------------------------------
  bool isLoading=false;
  double heightBetweenWidgets=20;
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

    //----------------------------------------Phone Number Register----------------------------------------
    // Future<void> phoneNUmberRegister(UserCredential userCredential) async {
    //   print("Phone Number: ${number.phoneNumber}");
    //
    //   try {
    //     await FirebaseAuth.instance.verifyPhoneNumber(
    //       phoneNumber: number.phoneNumber,
    //
    //       verificationCompleted: (phoneAuthCredential) async {
    //         await userCredential.user!.linkWithCredential(phoneAuthCredential);
    //
    //       },
    //       verificationFailed: (error) {
    //         if (error.code == 'invalid-phone-number') {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text('Invalid Phone Number')),
    //           );
    //         } else {
    //           ScaffoldMessenger.of(context).showSnackBar(
    //             SnackBar(content: Text(error.message ?? 'Phone verification failed')),
    //           );
    //         }
    //       },
    //       codeSent: (verificationId, forceResendingToken) {
    //         setState(() {
    //           verificationCode = verificationId;
    //         });
    //
    //         // Navigate to OTP verification screen
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => OtpVerify(verificationCode: verificationCode),
    //           ),
    //         );
    //       },
    //       codeAutoRetrievalTimeout: (verificationId) {
    //         verificationCode = verificationId;
    //       },
    //     );
    //   } on FirebaseAuthException catch (e) {
    //
    //     errorMessage = e.message;
    //   }
    // }

    //----------------------------------------Sign In with email and password----------------------------------------


    Future<void> signInWithEmailAndPassword() async{
      setState(() {
        isLoading=true;
        errorMessage=null;
      });
      if(emailValidation(emailController.text.trim()) != null || passwordValidation(passwordController.text.trim()) != null  ){
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

       // await phoneNUmberRegister(userCredential);

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
                    hint: 'Email',
                    preIcon: Icon(Icons.email_outlined),
                    valueController: emailController, validationFunction: emailValidation,
                    onErrorChange: (value){
                      setState(() {
                        emailErrorMessage=value;
                      });
                    }, errorFlag: emailFlag,
                  ),
                  SizedBox(height: heightBetweenWidgets,),

                  if(emailErrorMessage!=null)
                    Text(emailErrorMessage!,style: KStyle.errorMessageTextStyle,),

                ],
              ),
              SizedBox(height: heightBetweenWidgets),


              //----------------------------------------Password----------------------------------------
              Text('Password', style: KStyle.headerTextStyle),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCostume(
                    hint: 'PassWord',
                    preIcon: Icon(Icons.lock_outline),
                    sufIconUnpressed: Icon(Icons.visibility_off_outlined),
                    sufIconPressed: Icon(Icons.visibility_outlined),
                    valueController: passwordController, validationFunction: passwordValidation, errorFlag: passwordFlag,
                    onErrorChange: (value){
                      setState(() {
                        passwordErrorMessage=value;
                      });
                    },
                  ),
                  SizedBox(height: heightBetweenWidgets,),

                  if(passwordErrorMessage!=null)
                    Text(passwordErrorMessage!,style: KStyle.errorMessageTextStyle,),
                ],
              ),
              SizedBox(height: heightBetweenWidgets,),

              FittedBox(child: Text('Phone Number', style: KStyle.headerTextStyle)),
              //----------------------------------------Phone Number----------------------------------------
              // InternationalPhoneNumberInput(
              //
              //   onInputChanged: (PhoneNumber number) {
              //     setState(() {
              //       this.number = number;
              //
              //     });
              //   },
              //   selectorConfig: SelectorConfig(
              //     selectorType: PhoneInputSelectorType.DIALOG,
              //     showFlags: false,
              //     setSelectorButtonAsPrefixIcon: true,
              //   ),
              //   textFieldController: TextEditingController(),
              //   inputDecoration: InputDecoration(
              //
              //     labelText: "Phone Number",
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(20)
              //     ),
              //   ),
              //   initialValue: number,
              //   inputBorder: OutlineInputBorder(
              //
              //   ),
              // ),
              // SizedBox(height: heightBetweenWidgets),
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

class TextFieldCostume extends StatefulWidget {
  const TextFieldCostume({
    super.key,
    required this.hint,
    required this.preIcon,
    this.sufIconUnpressed,
    this.sufIconPressed,
    required this.valueController,
    required this.validationFunction,
    this.onErrorChange,
    required this.errorFlag,
  });
  final String hint;
  final Icon preIcon;
  final Icon? sufIconUnpressed;
  final Icon? sufIconPressed;
  final TextEditingController valueController;
  final Function validationFunction;
  final Function(String?)? onErrorChange;
  final bool errorFlag;

  @override
  State<TextFieldCostume> createState() => _TextFieldCostumeState();
}

class _TextFieldCostumeState extends State<TextFieldCostume> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        setState(() {
          final error= widget.validationFunction(value);
          if(widget.onErrorChange!=null){
            widget.onErrorChange!(error);
          }
          setState(() { });
        });
      },
      controller: widget.valueController,
      decoration: InputDecoration(
        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: widget.errorFlag? Colors.red : Colors.blue),

        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: widget.errorFlag? Colors.red : Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: widget.errorFlag? Colors.red : Colors.blue),
        ),
        hintText: widget.hint ,
        hintStyle: KStyle.normalTextStyle,
        prefixIcon: widget.preIcon,
        suffixIcon:
        widget.sufIconUnpressed != null
            ? IconButton(
          onPressed: () {
            setState(() {
              isPressed = !isPressed;
            });
          },
          icon:
          isPressed
              ? widget.sufIconPressed!
              : widget.sufIconUnpressed!,
        )
            : null,
      ),
      obscureText: (widget.sufIconUnpressed != null) ? !isPressed : false,

    );
  }
}
