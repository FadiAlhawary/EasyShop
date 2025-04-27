import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/Lists/CategoryList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../data/Constants.dart';
import '../widgets/Text_Field_Costume.dart';

class ProductsUploader extends StatefulWidget {
  const ProductsUploader({super.key});

  @override
  State<ProductsUploader> createState() => _ProductsUploader();
}

class _ProductsUploader extends State<ProductsUploader> {
  //------------------------------------------------------------Controllers------------------------------------------------------------
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final sizeController = TextEditingController();
  String? categoryValue;
  double height = 20;
  List<File> selectedImages = [];
  List<String> uploadedImagesUrl = [];
  bool isLoading = false;
  var uuid = Uuid();
  List<String>sizeList=[];
  //------------------------------------------------------------Add photo------------------------------------------------------------
  Future<void> selectImageFromGallery() async {
    final returnedImages = await ImagePicker().pickMultiImage(
      // source: ImageSource.gallery,
    );
    if (returnedImages != null && returnedImages.isNotEmpty) {
      setState(() {
        selectedImages =
            returnedImages
                .take(3)
                .map((img) => File(img.path))
                .toList(); // Convert XFile to File
      });
    }
  }
//------------------------------------------------------------Alert Dialog for Size------------------------------------------------------------
  Future<void> sizeAlertDialog() async{
    List<String> tempList=[];
    await showDialog(context: context, builder: (context) {
             return   AlertDialog(
               title: Text(
                 'Enter Size if any',
                 style: KStyle.normalTextStyle,
               ),
               content: StatefulBuilder(
                 builder: (context, setState) {
                   return Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       TextFieldCostume(
                         hint: 'Enter Size',
                         preIcon: Icon(Icons.straighten),
                         valueController: sizeController,
                         validationFunction: sizeValidation,
                         errorFlag: sizeFlag,
                         messageError: sizeMessageError,
                         isNumber: false,
                       ),
                       SizedBox(
                         height: height,
                       ),
                       FilledButton(onPressed: () {
                         if (sizeController.text.trim().isNotEmpty &&
                             !tempList.contains(sizeController.text.trim())) {
                           setState(() {
                             tempList.add(sizeController.text.trim());
                             sizeController.clear();
                           });
                         }
                       }, child: Text('ADD',style: KStyle.normalTextStyle,)),
                       SizedBox(height: height,),
                       Wrap(
                         spacing: 8,
                         runSpacing: 8,
                         children: tempList.map((size) => Chip(label: Text(size))).toList(),
                       ),

                     ],
                   );

                 },

               ),
               actions: [
                 ElevatedButton(onPressed: () {
                   setState(() {
                     sizeList=tempList;

                   });
                    sizeController.clear();
                   Navigator.pop(context);
                 }, child:Text('Done'))
               ],
             );
    },);
  }
  //------------------------------------------------------------Sending data------------------------------------------------------------
  Future<bool> sendingData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userUID = await FirebaseAuth.instance.currentUser!.uid;
      final fireStore =
          await FirebaseFirestore.instance.collection('products').doc();
      if (!priceFlag &&
          !nameFlag &&
          !quantityFlag &&
          categoryValue != null &&

          !descriptionFlag &&
          selectedImages.isNotEmpty) {
        for (int i = 0; i < selectedImages.length; i++) {
          final imageFile = selectedImages[i];
          final imagesRef = await FirebaseStorage.instance
              .ref('images')
              .child('productImage')
              .child(uuid.v4());
          final uploadTask = imagesRef.putFile(imageFile);
          final taskSnapshot = await uploadTask;
          final imageURL = await taskSnapshot.ref.getDownloadURL();
          uploadedImagesUrl.add(imageURL);
        }
        await fireStore.set({
          'Category': categoryValue,
          'Description': descriptionController.text.trim(),
          'Name': nameController.text.trim(),
          'Price': double.tryParse(priceController.text.trim()) ?? 0.0, // Convert price to double
          'Quantity': int.tryParse(quantityController.text.trim()) ?? 0,
          'UserID': userUID,
          'DateOfUpload': DateTime.now(),
          'Size': sizeList,
          'PhotosURL': uploadedImagesUrl,
        });
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  //------------------------------------------------------------Size Validations------------------------------------------------------------

  String? sizeMessageError;
  bool sizeFlag = true;
  String? sizeValidation(String value) {
    if (value.isEmpty) {
      setState(() {
        sizeFlag = true;
        sizeMessageError = 'Size is Empty';
      });
      return sizeMessageError;
    }

    setState(() {
      sizeFlag = false;
      sizeMessageError = null;
    });
    return sizeMessageError;
  }

  //------------------------------------------------------------Name Validations------------------------------------------------------------

  String? nameMessageError;
  bool nameFlag = true;
  String? nameValidation(String value) {
    if (value.isEmpty) {
      setState(() {
        nameFlag = true;
        nameMessageError = 'Name is Empty';
      });
      return nameMessageError;
    }

    setState(() {
      nameFlag = false;
      nameMessageError = null;
    });
    return nameMessageError;
  }

  //------------------------------------------------------------Price Validations------------------------------------------------------------
  String? priceMessageError;
  bool priceFlag = true;
  String? priceValidation(String value) {
    if (value.isEmpty) {
      setState(() {
        priceFlag = true;
        priceMessageError = 'Price Field is Empty';
      });
    } else {
      setState(() {
        priceFlag = false;
        priceMessageError = null;
      });
    }
    return priceMessageError;
  }

  //------------------------------------------------------------Quantity Validations------------------------------------------------------------
  String? quantityMessageError;
  bool quantityFlag = true;
  String? quantityValidation(String value) {
    if (value.isEmpty) {
      setState(() {
        quantityFlag = true;
        quantityMessageError = 'Quantity Field is Empty';
      });
    } else {
      setState(() {
        quantityFlag = false;
        quantityMessageError = null;
      });
    }
    return quantityMessageError;
  }

  //------------------------------------------------------------Description Validations------------------------------------------------------------
  String? descriptionMessageError;
  bool descriptionFlag = true;
  String? descriptionValidation(String value) {
    if (value.isEmpty) {
      setState(() {
        descriptionFlag = true;
        descriptionMessageError = 'Description Field is Empty';
      });
    } else {
      setState(() {
        descriptionFlag = false;
        descriptionMessageError = null;
      });
    }
    return descriptionMessageError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //------------------------------------------------------------Photos------------------------------------------------------------
              Column(
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      selectImageFromGallery();
                    },
                    child: Icon(Icons.file_upload),
                  ),
                  Text('Add Photos', style: KStyle.normalTextStyle),
                ],
              ),
              GridView.builder(
                itemCount: selectedImages.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return Image.file(selectedImages[index], fit: BoxFit.cover);
                },
              ),
              //------------------------------------------------------------Name------------------------------------------------------------
              TextFieldCostume(
                maxLetters: 50,
                hint: 'Product Name',
                preIcon: Icon(Icons.terrain_sharp),
                valueController: nameController,
                validationFunction: nameValidation,
                errorFlag: nameFlag,
                messageError: nameMessageError,
                isNumber: false,
              ),
              SizedBox(height: height),

              //------------------------------------------------------------Price------------------------------------------------------------
              TextFieldCostume(
                maxLetters: 4,
                hint: 'Price',
                preIcon: Icon(Icons.monetization_on_outlined),
                valueController: priceController,
                validationFunction: priceValidation,
                errorFlag: priceFlag,
                messageError: priceMessageError,
                isNumber: true,
              ),
              SizedBox(height: height),
              //------------------------------------------------------------Quantity------------------------------------------------------------
              TextFieldCostume(
                maxLetters: 4,
                hint: 'Quantity',
                preIcon: Icon(Icons.numbers_outlined),
                valueController: quantityController,
                validationFunction: quantityValidation,
                errorFlag: quantityFlag,
                messageError: quantityMessageError,
                isNumber: true,
              ),

              //------------------------------------------------------------Category------------------------------------------------------------
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: categoryValue == null ? Colors.red : Colors.blue,
                  ),
                ),
                child: DropdownButton<String>(
                  value: categoryValue,
                  borderRadius: BorderRadius.circular(20),
                  isExpanded: true,
                  hint: Text("Select Category", style: KStyle.titleTextStyle),
                  items:
                      category.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['label'],
                          child: Text(
                            cat['label'],
                            style: KStyle.normalTextStyle,
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryValue = value;
                    });
                  },
                ),
              ),
              SizedBox(height: height),

              //------------------------------------------------------------Description------------------------------------------------------------
              TextFieldCostume(
                maxLetters: 200,
                hint: 'Description',
                preIcon: Icon(Icons.description_outlined),
                valueController: descriptionController,
                validationFunction: descriptionValidation,
                errorFlag: descriptionFlag,
                messageError: descriptionMessageError,
                isNumber: false,
              ),
              //----------------------------------------Sized----------------------------------------

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {
                  sizeAlertDialog();
                }, child: Text('Enter Sizes if any')),
              ),
              SizedBox(
                height: height,
              ),
              //------------------------------------------------------------Upload------------------------------------------------------------
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    isLoading
                        ? null
                        : await sendingData()
                        ? Navigator.pop(context)
                        : null;
                  },
                  child:
                      isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
