
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/Constants.dart';

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
    required this.messageError,
    required this.isNumber,
    this. maxLetters,
    this.maxLines,
  });
  final String hint;
  final Icon preIcon;
  final Icon? sufIconUnpressed;
  final Icon? sufIconPressed;
  final TextEditingController valueController;
  final Function validationFunction;
  final Function(String?)? onErrorChange;
  final bool errorFlag;
  final String? messageError;
  final bool isNumber;
  final int? maxLetters;
  final int? maxLines;

  @override
  State<TextFieldCostume> createState() => _TextFieldCostumeState();
}

class _TextFieldCostumeState extends State<TextFieldCostume> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        TextField(
          maxLines: widget.maxLines,
          maxLength: widget.maxLetters,
          inputFormatters: widget.isNumber? <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ] : null,
      keyboardType: widget.isNumber? TextInputType.number : TextInputType.text ,
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

        ),
        if(widget.messageError!=null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0 ,vertical: 0),
            child: Text(widget.messageError!,style: KStyle.errorMessageTextStyle,),
          ),

      ],
    );
  }
}
