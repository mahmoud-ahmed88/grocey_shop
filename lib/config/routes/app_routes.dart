import 'package:flutter/material.dart';
import 'package:product_shop/presentation/pages/auth_wrapper.dart';
import 'package:product_shop/presentation/pages/my_details_page.dart';
import 'package:product_shop/presentation/pages/profile_page.dart';
import 'package:product_shop/presentation/widget/cart.dart';
import 'package:product_shop/presentation/widget/signup.dart';
import 'package:product_shop/presentation/widget/login.dart';
import 'package:product_shop/presentation/widget/home.dart';

class AppRoutes {
  static const String authWrapper = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String myDetails = '/my-details';
  static const String cart = '/cart';
  static const String profile = '/profile';


  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case myDetails:
        return MaterialPageRoute(builder: (_) => const MyDetailsPage());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))));
    }
  }
}
