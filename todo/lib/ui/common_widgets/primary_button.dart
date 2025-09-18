import 'package:todo/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const PrimaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.backgroundColor,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
