import 'package:todo/data/repositories/user_repository.dart';
import 'package:todo/ui/screens/home/home.dart';
import 'package:todo/ui/screens/login/login.dart';
import 'package:todo/ui/screens/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:todo/ui/screens/login/login_cubit.dart';
import 'package:todo/ui/screens/register/register.dart';
import 'package:todo/ui/screens/register/register_cubit.dart';
import 'package:todo/ui/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Amritha Ayurveda',
          theme: ThemeData(
            fontFamily: 'Poppins',
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          ),
          home: HomeScreen(),
          // BlocProvider(
          //   create: (context) => RegisterCubit(),
          //   child: RegisterScreen(),
          // ),
          // BlocProvider(
          //   create: (context) => LoginCubit(UserRepository()),
          //   child: LoginScreen(),
          // ),
        );
      },
    );
  }
}
