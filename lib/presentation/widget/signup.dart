import 'package:flutter/material.dart';
import 'package:product_shop/config/routes/app_routes.dart';

class SignUpPage extends StatefulWidget {
	const SignUpPage({super.key});

	@override
	State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
	final _formKey = GlobalKey<FormState>();
	final nameController = TextEditingController();
	final emailController = TextEditingController();
	final passwordController = TextEditingController();
	final addressController = TextEditingController();
	final phoneController = TextEditingController();

	@override
	void dispose() {
		nameController.dispose();
		emailController.dispose();
		passwordController.dispose();
		addressController.dispose();
		phoneController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Sign Up')),
			body: Padding(
				padding: const EdgeInsets.all(20),
				child: SingleChildScrollView(
					child: Form(
						key: _formKey,
						child: Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Image.asset('assets/images/logo.png', height: 120),

								const SizedBox(height: 16),

								TextFormField(
									controller: nameController,
									decoration: const InputDecoration(labelText: 'Full Name'),
									validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your full name' : null,
								),

								const SizedBox(height: 10),

								TextFormField(
									controller: emailController,
									decoration: const InputDecoration(labelText: 'Email'),
									keyboardType: TextInputType.emailAddress,
									validator: (v) {
										if (v == null || v.trim().isEmpty) return 'Please enter an email';
										final val = v.trim();
										final at = val.indexOf('@');
										if (at <= 0) return 'Email must contain @ and some name before it';
										final after = val.substring(at + 1);
										if (after.length < 3) return 'There must be at least 3 characters after @';
										return null;
									},
								),

								const SizedBox(height: 10),

								TextFormField(
									controller: passwordController,
									obscureText: true,
									decoration: const InputDecoration(labelText: 'Password'),
									validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
								),

								const SizedBox(height: 10),

								TextFormField(
									controller: addressController,
									decoration: const InputDecoration(labelText: 'Address'),
									validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your address' : null,
								),

								const SizedBox(height: 10),

								TextFormField(
									controller: phoneController,
									decoration: const InputDecoration(labelText: 'Phone'),
									keyboardType: TextInputType.phone,
									validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a phone number' : null,
								),

								const SizedBox(height: 20),

								ElevatedButton(
									onPressed: () {
										if (!_formKey.currentState!.validate()) return;

										Navigator.pushReplacementNamed(
											context,
											AppRoutes.home,
											arguments: {
												'name': nameController.text.trim(),
												'email': emailController.text.trim(),
												'password': passwordController.text,
												'address': addressController.text.trim(),
												'phone': phoneController.text.trim(),
											},
										);
									},
									child: const Text('Create Account'),
								),
							],
						),
					),
				),
			),
		);
	}
}
