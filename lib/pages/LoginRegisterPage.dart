import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../models/user_model.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library App'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,
          child: Column(
            children: [

              Image.network(
                  width: double.infinity, height: 300,
                  'https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg',
                  fit: BoxFit.cover,
                ),
         

         SizedBox(height: 25),

              TextFormField(
                controller: userController,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter email';
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: passController,
                obscureText: hidePassword,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter password';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),

                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {

                      UserCredential cred =
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: userController.text.trim(),
                        password: passController.text.trim(),
                      );

                      final uid = cred.user!.uid;

                      final doc = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .get();

                      if (doc.exists) {
                        final data = doc.data()!;

                        final user = UserModel(
                          uid: uid,
                          email: data["email"],
                          isAdmin: data["isAdmin"] ?? false,
                        );

                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(user);
                      }

                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }

                    } on FirebaseAuthException catch (e) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login failed — please try again"),
                        ),
                      );
                    }
                  }
                },

                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
                child: const Text(
                  "Create new account",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
