import 'package:chat_app/constants/colors/app_pallete.dart';
// import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/model/model/user_model.dart';
// import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/view/chat_screen/chat_screen.dart';
import 'package:chat_app/viewmodel/controllers/auth_controller.dart';

import 'package:chat_app/widgets/custom_text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();
  List<UserModel> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: authController.user!.uid)
        .get();
    setState(() {
      userList = snapshot.docs.map((doc) => UserModel.fromSnap(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Messages"),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 120.w,
              height: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0.sp),
                    onPressed: () {
                      authController.signOut();
                    },
                    icon: Icon(
                      size: 25.dg,
                      color: Theme.of(context).colorScheme.tertiary,
                      Icons.logout_rounded,
                    ),
                  ),
                  Text(
                    "Logout   ",
                    style: CustomTextStyle.bodyText1.copyWith(
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.background),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                UserModel user = userList[index];
                return Padding(
                  padding: EdgeInsets.only(
                    top: 8.w,
                    right: 8.w,
                    left: 8.w,
                  ),
                  child: ListTile(
                    onTap: () {
                      // Navigate to chat screen
                      Get.to(() => ChatScreen(receiver: user));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r)),
                    tileColor: Theme.of(context).colorScheme.tertiary,
                    leading: CircleAvatar(
                      radius: 25.r,
                      backgroundImage: NetworkImage(user.profilePicture),
                    ),
                    title: Text(
                      user.name,
                      style: CustomTextStyle.bodyText1.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(user.email),
                  ),
                );
              },
            ),
    );
  }
}
