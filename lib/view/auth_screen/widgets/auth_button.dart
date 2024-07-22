import 'package:chat_app/constants/colors/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: AppPallete.buttonColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
