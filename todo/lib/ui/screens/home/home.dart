import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          textAlign: TextAlign.justify,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome, ",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextSpan(
                                text: "Vimal!",
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              cursorColor: Colors.black,

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                hintText: "Search..",
                                hintStyle: TextStyle(
                                  color: AppColors.hintColor,
                                  fontSize: 16.sp,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.greyColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: AppColors.borderColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: AppColors.borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(
                                    color: AppColors.borderColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              backgroundColor: AppColors.buttonColor,
                              foregroundColor: AppColors.backgroundColor,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Scan Here",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(children: [

          ],
        ),
          ],
        ),
      ),
    );
  }
}
