import 'package:chat_app/view/auth_screen/login_screen.dart';
import 'package:chat_app/view/auth_screen/signup_screen.dart';
import 'package:chat_app/view/chat_screen/chat_screen.dart';
import 'package:chat_app/view/home_screen.dart/home_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class RoutesHelper {
  static const String loginScreen = "/login-in-screen";
  static const String signupScreen = "/sign-up-screen";
  static const String homeScreen = "/home-screen";
  static const String chatScreen = "/chat-screen";

  static String getLoginScreen() => loginScreen;
  static String getSignupScreen() => signupScreen;
  static String getHomeScreen() => homeScreen;
  static String getChatScreen() => chatScreen;

  static List<GetPage> routes = [
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: signupScreen,
      page: () => const SignupScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // GetPage(
    //   name: chatScreen,
    //   page: () => const ChatScreen(receiver: ),
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 300),
    // ),
  ];
}
