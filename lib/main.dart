import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_shop/config/routes/app_routes.dart';
import 'package:product_shop/config/routes/product_cubit.dart';
import 'package:product_shop/presentation/pages/auth_cubit.dart';
import 'package:product_shop/presentation/pages/cart_cubit.dart';
import 'package:product_shop/presentation/pages/auth_wrapper.dart';
import 'package:product_shop/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => ProductCubit()..fetchProducts()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: const AuthWrapper(),
      ),
    );
  }
}
