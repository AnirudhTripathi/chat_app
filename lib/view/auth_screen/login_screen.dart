import 'package:chat_app/constants/colors/app_pallete.dart';
import 'package:chat_app/routes/routes_helper.dart';
import 'package:chat_app/view/auth_screen/widgets/auth_button.dart';
import 'package:chat_app/view/auth_screen/widgets/auth_textfeild.dart';
import 'package:chat_app/viewmodel/controllers/auth_controller.dart';
import 'package:chat_app/widgets/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _controller = Get.find<AuthController>();

  @override
  void dispose() {
    _controller.emailController.dispose();
    _controller.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Image.asset(
              "assets/images/chat_icon.png",
              // scale: .5,
              height: 250.h,
            ),
            Text(
              textAlign: TextAlign.center,
              "Welcome! To our Chat App\nLet's Connect",
              style: CustomTextStyle.bodyText1
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(
              height: 30.h,
            ),
            AuthTextfeild(
              hintText: 'Email',
              controller: _controller.emailController,
              icon: Icons.email_outlined,
            ),
            SizedBox(
              height: 20.h,
            ),
            AuthTextfeild(
              hintText: 'Password',
              obscureText: true,
              controller: _controller.passwordController,
              icon: Icons.lock_open_outlined,
            ),
            SizedBox(
              height: 40.h,
            ),
            AuthButton(
              buttonText: "Login",
              onPressed: () {
                _controller.login(
                  _controller.emailController.text.trim(),
                  _controller.passwordController.text.trim(),
                );
              },
            ),
            SizedBox(
              height: 80.h,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(RoutesHelper.signupScreen);
              },
              child: RichText(
                text: TextSpan(
                  text: 'Don\'t Have an Account? ',
                  style: CustomTextStyle.bodyText2.copyWith(
                      fontSize: 15.sp,
                      color: Theme.of(context).colorScheme.primary),
                  children: [
                    TextSpan(
                        text: 'Sign Up',
                        style: CustomTextStyle.bodyText2.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                            color: AppPallete.buttonColor))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
