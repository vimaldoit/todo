import 'package:todo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextFormField(
        controller: controller,
        validator: validator,
        textAlign: TextAlign.left,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          isDense: false,
          contentPadding: EdgeInsets.only(left: 10, right: 10),
          filled: true,
          fillColor: AppColors.inputBoxColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.borderColor, width: 2),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.hintColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
          ),
          errorStyle: TextStyle(fontSize: 12, height: 1.1),
        ),
      ),
    );
  }
}
