import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:todo/ui/common_widgets/custom_textform.dart';
import 'package:todo/ui/common_widgets/inputbox_header.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();

  final List<Map<String, dynamic>> locations = [
    {'value': 1, 'label': 'Date'},
    {'value': 2, 'label': 'Name'},
    {'value': 3, 'label': 'Priority'},
  ];
  int? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.5.h),
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 30,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Register",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Divider(color: AppColors.borderColor, height: 0),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputBoxHeader(title: "Name"),
                    SizedBox(height: 5),
                    CustomTextfield(
                      controller: _nameController,
                      hintText: "Enter your full name",
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    InputBoxHeader(title: "Whatsapp number"),
                    SizedBox(height: 5),
                    CustomTextfield(
                      controller: _whatsappController,
                      hintText: "Enter your whatsapp number",
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Whatsapp number is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    InputBoxHeader(title: "Address"),
                    SizedBox(height: 5),
                    CustomTextfield(
                      controller: _addressController,
                      hintText: "Enter your address",
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    InputBoxHeader(title: "Location"),
                    SizedBox(height: 5),

                    DropdownButtonFormField<int>(
                      value: selectedLocation,

                      onChanged: (val) {},
                      decoration: dropDowndecoration(
                        context: context,
                        hintText: 'Choose locations',
                      ),
                      items:
                          locations.map((option) {
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              child: Text(
                                option['label'],
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // name,
          // wharsapp number
          // addresss,
        ],
      ),
    );
  }
}
