import 'package:flutter/material.dart';
import 'package:product_shop/presentation/pages/my_details_page.dart';

class MyDetailsViewPage extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String address;
  final String phone;

  const MyDetailsViewPage({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
  });

  @override
  State<MyDetailsViewPage> createState() => _MyDetailsViewPageState();
}

class _MyDetailsViewPageState extends State<MyDetailsViewPage> {
  late String name;
  late String email;
  late String password;
  late String address;
  late String phone;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    password = widget.password;
    address = widget.address;
    phone = widget.phone;
  }

  Future<void> _onEdit() async {
    final navigator = Navigator.of(context);

    // فتح صفحة التعديل بدون تمرير متغيرات
    final result = await navigator.push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => const MyDetailsPage(), // الحل النهائي
      ),
    );

    if (!mounted) return;

    // تحديث البيانات بعد الرجوع من صفحة التعديل
    if (result != null) {
      setState(() {
        name = result['name'] ?? name;
        email = result['email'] ?? email;
        password = result['password'] ?? password;
        address = result['address'] ?? address;
        phone = result['phone'] ?? phone;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('update completed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),

            Text('Email', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(email, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),

            Text('Address', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(address.isEmpty ? '-' : address, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),

            Text('Phone', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 6),
            Text(phone.isEmpty ? '-' : phone, style: const TextStyle(fontSize: 18)),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onEdit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Edit', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
