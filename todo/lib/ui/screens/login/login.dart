import 'package:todo/ui/common_widgets/app_loader.dart';
import 'package:todo/ui/common_widgets/custom_textform.dart';
import 'package:todo/ui/common_widgets/inputbox_header.dart';
import 'package:todo/ui/common_widgets/primary_button.dart';
import 'package:todo/ui/screens/login/login_cubit.dart';
import 'package:todo/ui/screens/register/register.dart';
import 'package:todo/ui/screens/register/register_cubit.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/custom_extession.dart';
import 'package:todo/utils/input_validations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = () {};
    _privacyRecognizer = TapGestureRecognizer()..onTap = () {};
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<LoginCubit>(
        context,
      ).userLogin(emailController.text.trim(), passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccesse) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider(
                      create: (context) => RegisterCubit(),
                      child: RegisterScreen(),
                    ),
              ),
              (route) => false,
            );
          }
          if (state is LoginFailure) {
            AppValidations.showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is LoginLoader) {
            return AppLoader();
          }

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/login_backgroundimage.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 25.h,
                width: 100.w,
                child: Center(
                  child: SizedBox(
                    height: 20.w,
                    width: 20.w,
                    child: SvgPicture.asset("assets/images/logo.svg"),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login or register to book your appointments"
                                    .toTitleCase(),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textColor,
                                ),
                              ),
                              SizedBox(height: 30),
                              InputBoxHeader(title: "Email"),
                              SizedBox(height: 10),
                              CustomTextfield(
                                controller: emailController,
                                hintText: "Enter your email",
                                validator: AppValidations.normalInputValidate,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 20),
                              InputBoxHeader(title: 'Password'),
                              SizedBox(height: 10),
                              CustomTextfield(
                                controller: passwordController,
                                hintText: "Enter password",
                                obscureText: true,
                                validator: AppValidations.validatePasswordInput,
                              ),
                              SizedBox(height: 10.h),
                              PrimaryButtonWidget(
                                label: "Login",
                                onPressed: _submit,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text.rich(
                            textAlign: TextAlign.justify,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "By creating or logging into an account you are agreeing with our ",
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: "Terms and Conditions ",
                                  style: TextStyle(
                                    color: AppColors.blueColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: _termsRecognizer,
                                ),
                                TextSpan(
                                  text: "and",
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                TextSpan(
                                  text: " Privacy Policy.",
                                  style: TextStyle(
                                    color: AppColors.blueColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: _privacyRecognizer,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
