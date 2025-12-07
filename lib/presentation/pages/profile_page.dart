import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_shop/config/routes/app_routes.dart';
import 'package:product_shop/presentation/pages/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // يجب ألا يحدث هذا إذا كان AuthWrapper يعمل بشكل صحيح
      return const Center(child: Text('User not logged in.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              // تسجيل الخروج عند الضغط
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // الاستماع لبيانات المستخدم من Firestore بشكل حي
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            // في حال لم تكن بيانات المستخدم موجودة في Firestore
            return _buildProfileView(context, name: user.displayName, email: user.email);
          }

          // عرض البيانات من Firestore
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return _buildProfileView(
            context,
            name: userData['name'] ?? user.displayName,
            email: userData['email'] ?? user.email,
            address: userData['address'],
            phone: userData['phone'],
          );
        },
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, {String? name, String? email, String? address, String? phone}) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        CircleAvatar(
          radius: 50,
          child: Text(name?.substring(0, 1).toUpperCase() ?? 'U', style: const TextStyle(fontSize: 40)),
        ),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(name ?? 'No Name'),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(email ?? 'No Email'),
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(address ?? 'No Address Provided'),
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: Text(phone ?? 'No Phone Provided'),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.myDetails),
          child: const Text('Edit Details'),
        ),
      ],
    );
  }
}