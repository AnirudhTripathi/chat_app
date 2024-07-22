import 'package:chat_app/constants/colors/app_pallete.dart';
import 'package:chat_app/view/auth_screen/widgets/auth_button.dart';
import 'package:chat_app/view/auth_screen/widgets/auth_textfeild.dart';
import 'package:chat_app/viewmodel/controllers/auth_controller.dart';
import 'package:chat_app/widgets/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
            ),
            InkWell(
              onTap: () => AuthController.instance.pickImage(),
              child: Stack(
                children: [
                  Obx(() {
                    final pickedImage = _controller.profilePhoto;
                    return CircleAvatar(
                      radius: 80.r,
                      backgroundImage: pickedImage != null
                          ? FileImage(pickedImage)
                          : const NetworkImage(
                              "https://i.pinimg.com/564x/de/6e/8d/de6e8d53598eecfb6a2d86919b267791.jpg",
                            ) as ImageProvider,
                    );
                  }),
                  Positioned(
                    bottom: 0.h,
                    left: 120.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.edit,
                          size: 25.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 80.h,
            ),
            AuthTextfeild(
              hintText: 'Username',
              controller: usernameController,
              icon: Icons.person_add_alt,
            ),
            SizedBox(
              height: 20.h,
            ),
            AuthTextfeild(
              hintText: 'Email',
              controller: emailController,
              icon: Icons.email_outlined,
            ),
            SizedBox(
              height: 20.h,
            ),
            AuthTextfeild(
              hintText: 'Password',
              obscureText: true,
              controller: passwordController,
              icon: Icons.lock_open_outlined,
            ),
            SizedBox(
              height: 40.h,
            ),
            AuthButton(
              buttonText: "Sign up",
              onPressed: () {
                AuthController.instance.registerUser(
                  emailController.text,
                  usernameController.text,
                  passwordController.text,
                  AuthController.instance.profilePhoto,
                );
                
              },
            ),
          ],
        ),
      ),
    );
  }
}
