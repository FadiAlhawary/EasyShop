import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/pages/Log_In.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

File? selectedImage;

class _ProfileState extends State<Profile> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate(); // Convert Timestamp to DateTime
    return DateFormat('dd/MM/yyyy').format(date); // Format as "day/month/year"
  }

  Future<void> selectImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (returnedImage != null) {
      setState(() {
        selectedImage = File(returnedImage.path); // Convert XFile to File
      });
    }
  }

  //------------------------------------------------------------Controllers------------------------------------------------------------
  final nameController = TextEditingController();
  final bodController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  final confirmationPasswordController = TextEditingController();
  bool isPasswordHidden = true;
  bool _isPasswordVerified = false;
  String? _passwordError;
  //------------------------------------------------------------Date Picker------------------------------------------------------------
  Future<void> _setDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1940),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      dateController.text = picked.toString().split(" ")[0];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    confirmationPasswordController.dispose();
    bodController.dispose();
    emailController.dispose();
    dateController.dispose();
    nameController.dispose();
    confirmationPasswordController.dispose();
    _isPasswordVerified=false;
    _passwordError=null;
    super.dispose();
  }
@override

  @override
  Widget build(BuildContext context) {
    //----------------------------------------Change Profile----------------------------------------
    bool isLoadingProfile = false;
    Future<void> changeProfileImage() async {
      try {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final imagesRef = await FirebaseStorage.instance
            .ref('images')
            .child('profileImage')
            .child(FirebaseAuth.instance.currentUser!.uid);
        final uploadTask = imagesRef.putFile(selectedImage!);
        final taskSnapshot = await uploadTask;
        final imageURL = await taskSnapshot.ref.getDownloadURL();
        print(imageURL);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'profileImageUrl': imageURL});
        await prefs.setString(KConstants.imageURLConstant, imageURL);
      } catch (e) {
        print(e);
      }
    }

    //------------------------------------------------------------Updater------------------------------------------------------------
    Future<void> informationUpdater() async {
      final user =await FirebaseAuth.instance.currentUser!;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      //-----Name-----
      if (nameController.text.isNotEmpty) {
      await  FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'Name': nameController.text.trim()

        });
        await prefs.setString(KConstants.userNameConstant, nameController.text.trim());
      }
      //-----BirthDay-----
      if (dateController.text.isNotEmpty) {
       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'DOB': dateController,
        });
      }
      //-----Email-----
      if (emailController.text.isNotEmpty) {
        AuthCredential credential =await EmailAuthProvider.credential(
          email: user.email.toString(),
          password: confirmationPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);
        FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(
          emailController.text.trim(),
        );




        // await user.updateEmail(emailController.text.trim());
      }
    }
    //------------------------------------------------------------Confirmation Password------------------------------------------------------------

    // Replace your verifyPassword and update methods with these:
    Future<bool> verifyPassword(String password) async {
      if (password.isEmpty) {
        setState(() {
          _passwordError = 'Password cannot be empty';
          _isPasswordVerified = false;
        });

        return false;
      }

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null || user.email == null) return false;

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        setState(() {
          _passwordError = null;
          _isPasswordVerified = true;
        });

        informationUpdater();
        return true;
      } on FirebaseAuthException catch (e) {
        setState(() {
          _passwordError = 'Wrong password. Please try again';
          _isPasswordVerified = false;
        });
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User profile not found'));
          }
          final data = snapshot.data!.data();

          if (data == null) {
            return Text('No data available');
          }
          if (snapshot.hasData) {
            final data = snapshot.data!.data();
            print('data : ${data}');
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //------------------------------------------------------------Avatar Image------------------------------------------------------------
                    GestureDetector(
                      onTap: () {
                        print(
                          'image :    ${snapshot.data!['profileImageUrl']}',
                        );
                        selectImageFromGallery();
                        changeProfileImage();
                      },
                      child: SizedBox(
                        width: 230,
                        height: 230,
                        child: ClipOval(
                          child:
                              selectedImage != null
                                  ? Image.file(selectedImage!,fit: BoxFit.cover)
                                  : snapshot.data!['profileImageUrl'] != ''
                                  ? Image.network(
                                    snapshot.data!['profileImageUrl'],
                                  fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/no-connection.jpg', // Your offline fallback image
                                    fit: BoxFit.cover,
                                  );
                                },)
                                  : Image.asset('assets/images/npPerson.jpg'),

                           // Optional: Adjust size
                        ),
                      ),
                    ),

                    //------------------------------------------------------------Name------------------------------------------------------------
                    SizedBox(height: 50),
                    FittedBox(
                      child: Text(data!['Name'], style: KStyle.titleTextStyle),
                    ),
                    //------------------------------------------------------------Gender------------------------------------------------------------
                    CostumeListTile(
                      name: 'Gender',
                      content: data['Gender'] ? 'Male' : 'Female',
                    ),
                    //------------------------------------------------------------BOD------------------------------------------------------------
                    CostumeListTile(
                      name: 'Birthday',
                      content: formatTimestamp(data['DOB']),
                    ),
                    //------------------------------------------------------------Email------------------------------------------------------------
                    CostumeListTile(
                      name: 'Email',
                      content:
                          FirebaseAuth.instance.currentUser!.email.toString(),
                    ),
                    //------------------------------------------------------------Edit Profile------------------------------------------------------------
                    SizedBox(
                      height: 60,
                      child: FilledButton(
                        onPressed: () {
                          // FirebaseAuth.instance.signOut();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,

                            builder: (context) {
                              return SizedBox(
                                height: 800,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 120,
                                          height: 5,

                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                        ),
                                      ),

                                      Center(
                                        child: Text(
                                          'Edit Profile',
                                          style: KStyle.normalTextStyle,
                                        ),
                                      ),
                                      //------------------------------------------------------------Edit Name------------------------------------------------------------
                                      ChangerTextField(
                                        hint: data['Name'],
                                        controller: nameController,
                                        fieldName: 'Name',
                                      ),

                                      //------------------------------------------------------------Change Email------------------------------------------------------------
                                      ChangerTextField(
                                        hint:
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .email
                                                .toString(),
                                        controller: emailController,
                                        fieldName: 'Email',
                                      ),
                                      //------------------------------------------------------------Change DOB------------------------------------------------------------
                                      Text(
                                        'BirthDay',
                                        style: KStyle.leadingTextStyle,
                                      ),
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: dateController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          hintText: formatTimestamp(
                                            data['DOB'],
                                          ),
                                          prefixIcon: Icon(Icons.date_range),
                                          filled: true,
                                        ),
                                        readOnly: true,
                                        onTap: () {
                                          _setDate();
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      //------------------------------------------------------------Confirmation Password------------------------------------------------------------
                                      Text(
                                        'Confirmation Password',
                                        style: KStyle.leadingTextStyle,
                                      ),
                                      SizedBox(height: 10),
                                      StatefulBuilder(
                                        builder: (context, setState) {
                                          return Column(
                                            children: [
                                              TextField(
                                                controller:
                                                    confirmationPasswordController,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.lock_open_outlined,
                                                  ),
                                                  hintText: 'Password',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    borderSide: BorderSide(
                                                      color:
                                                          _isPasswordVerified
                                                              ? Colors.red
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                    borderSide: BorderSide(
                                                      color:
                                                          _isPasswordVerified
                                                              ? Colors.red
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                    borderSide: BorderSide(
                                                      color:
                                                          _isPasswordVerified
                                                              ? Colors.red
                                                              : Colors.blue,
                                                    ),
                                                  ),
                                              
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        isPasswordHidden =
                                                            !isPasswordHidden;
                                                      });
                                                    },
                                                    icon:
                                                        isPasswordHidden
                                                            ? Icon(
                                                              Icons
                                                                  .visibility_outlined,
                                                            )
                                                            : Icon(
                                                              Icons
                                                                  .visibility_off_outlined,
                                                            ),
                                                  ),
                                                ),
                                                obscureText: isPasswordHidden,
                                              ),
                                              Text(_passwordError!=null ? _passwordError! : ''),
                                            ],
                                          );
                                        },
                                      ),

                                      SizedBox(height: 40),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),

                                        //------------------------------------------------------------Confirmation => Cancel------------------------------------------------------------
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 50,

                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor: Color(
                                                          0xADC4DCFF,
                                                        ),
                                                      ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'CANCEL',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 25),
                                            //------------------------------------------------------------Confirmation => Save------------------------------------------------------------
                                            Expanded(
                                              child: SizedBox(
                                                height: 50,
                                                child: FilledButton(
                                                  style: FilledButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.lightBlue[700],
                                                  ),
                                                  onPressed: () async {
                                                    if (await verifyPassword(
                                                      confirmationPasswordController
                                                          .text
                                                          .trim(),
                                                    )) {
                                                      Navigator.pop(context);


                                                    }
                                                  },
                                                  child: Text('SAVE'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_outlined, size: 30),
                            Text(
                              '   Edit Profile',
                              style: TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //------------------------------------------------------------Log Out------------------------------------------------------------
                    SizedBox(
                      height: 60,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red[700],
                        ),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LogIn();
                              },
                            ),
                          );
                        },

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_outlined, size: 30),
                            Text('   LOGOUT', style: TextStyle(fontSize: 25)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('ERROR'));
          }
          return Center(child: Text('Unknown Error'));
        },
      ),
    );
  }
}

class CostumeListTile extends StatelessWidget {
  const CostumeListTile({super.key, required this.name, required this.content});
  final String name;
  final String content;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListTile(
        leading: Text('${name} :', style: KStyle.leadingTextStyle),
        title: Text(content, style: KStyle.normalTextStyle),
        trailing: IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: content)); // Copy text

            ClipboardData? data = await Clipboard.getData(
              Clipboard.kTextPlain,
            ); // Retrieve copied text
            print("Copied text: ${data?.text}"); // Print only the copied text
          },
          icon: Icon(Icons.copy_outlined),
        ),
      ),
    );
  }
}

class ChangerTextField extends StatelessWidget {
  const ChangerTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.fieldName,
    this.sufIcon,
    this.function,
    this.isReadOnly,
  });
  final String fieldName;
  final String hint;
  final TextEditingController controller;
  final Icon? sufIcon;
  final Function? function;
  final bool? isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName, style: KStyle.leadingTextStyle),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          readOnly: isReadOnly == null ? false : isReadOnly!,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: hint,
            hintStyle: KStyle.normalTextStyle,
            suffixIcon:
                sufIcon != null
                    ? IconButton(
                      onPressed: () {
                        function!();
                      },
                      icon: sufIcon!,
                    )
                    : null,
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
