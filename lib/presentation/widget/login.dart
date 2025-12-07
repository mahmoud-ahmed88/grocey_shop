import 'package:flutter/material.dart';
import 'package:product_shop/config/routes/app_routes.dart';
import 'package:product_shop/presentation/pages/auth_service.dart';

class LoginPage extends StatefulWidget {
	const LoginPage({super.key});

	@override
	State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final emailController = TextEditingController();
	final passwordController = TextEditingController();

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Login')),
			body: Padding(
				padding: const EdgeInsets.all(20.0),
				child: SingleChildScrollView( // حتى لا يحصل overflow في الشاشات الصغيرة
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							// 🖼️ إضافة اللوجو هنا
							Image.asset(
								'assets/images/logo.png', // المسار إلى الصورة
								height: 120,
								width: 120, // يمكنك تغييره حسب الحجم المطلوب
							),
							const SizedBox(height: 30),

							// 📧 حقل الإيميل
							TextField(
								controller: emailController,
								decoration: const InputDecoration(labelText: 'Email'),
							),
							const SizedBox(height: 10),

							// 🔒 حقل الباسورد
							TextField(
								controller: passwordController,
								obscureText: true,
								decoration: const InputDecoration(labelText: 'Password'),
							),
							const SizedBox(height: 20),

							// 🔘 زر تسجيل الدخول
							ElevatedButton(
								onPressed: () async {
									final email = emailController.text;
									final password = passwordController.text;
									if (email.isNotEmpty && password.isNotEmpty) {
										final authService = AuthService();
										final user = await authService.signInWithEmailAndPassword(email, password);
										if (user == null && mounted) {
											// حدث خطأ، عرض رسالة للمستخدم
											ScaffoldMessenger.of(context).showSnackBar(
												const SnackBar(content: Text('Login failed. Please check your credentials.')));
										}
										// في حالة النجاح، سيقوم AuthWrapper بالتعامل مع إعادة التوجيه تلقائيًا
									} else {
										ScaffoldMessenger.of(context).showSnackBar(
											const SnackBar(content: Text('Please enter email and password')));
									}
								},
								child: const Text('Login'),
							),

							const SizedBox(height: 15),
							const Text('OR'),
							const SizedBox(height: 15),

							// 🔘 زر تسجيل الدخول باستخدام جوجل
							ElevatedButton.icon(
								icon: Image.asset('assets/images/google_logo.png', height: 22.0), // تأكد من وجود الصورة في المسار المحدد
								onPressed: () async {
									final authService = AuthService();
									final user = await authService.signInWithGoogle();
									if (user != null && mounted) {
										// تم تسجيل الدخول بنجاح، انتقل إلى الصفحة الرئيسية
										// سيقوم AuthWrapper بالتعامل مع إعادة التوجيه
									} else if (mounted) {
										// حدث خطأ أو ألغى المستخدم العملية
										ScaffoldMessenger.of(context).showSnackBar(
												const SnackBar(content: Text('Google sign-in failed.')));
									}
								},
								label: const Text('Sign in with Google'),
							),

							// 🔗 رابط التسجيل
							TextButton(
								onPressed: () {
									Navigator.pushNamed(context, AppRoutes.signup);
								},
								child: const Text("Don't have an account? Sign Up"),
							),
						],
					),
				),
			),
		);
	}
}
