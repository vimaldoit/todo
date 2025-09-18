import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/user_repository.dart';
import 'package:todo/services/secure_storage_service.dart';
import 'package:todo/ui/screens/login/login.dart';
import 'package:todo/ui/screens/login/login_cubit.dart';
import 'package:todo/ui/screens/register/register.dart';
import 'package:todo/ui/screens/register/register_cubit.dart';
import 'package:todo/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkuser();
  }

  Future<void> checkuser() async {
    await Future.delayed(const Duration(seconds: 2));

    final SecureStorageService _storage = SecureStorageService();
    String? authToken = await _storage.getToken();
    if (authToken == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => LoginCubit(UserRepository()),
                child: LoginScreen(),
              ),
        ),
        (route) => false,
      );
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(child: Text("Loading ...")),
    );
  }
}
