import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/utils/colors.dart';

InputDecoration dropDowndecoration({
  required BuildContext context,
  required String hintText,
}) {
  return InputDecoration(
    isDense: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
    errorStyle: const TextStyle(fontSize: 12, height: 1.1),
  );
}
