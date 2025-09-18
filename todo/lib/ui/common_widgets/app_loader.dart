import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppLoader extends StatelessWidget {
  final int loaderHeight;
  const AppLoader({Key? key, this.loaderHeight = 90}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 100.w,
      height: loaderHeight.h,
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
