import 'package:todo/utils/colors.dart';
import 'package:flutter/widgets.dart';

class InputBoxHeader extends StatelessWidget {
  final String title;
  const InputBoxHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),
    );
  }
}
