import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../models/user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [

              const SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                validator: (v){
                  if(v == null || v.isEmpty) return "Required Name";
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Name",
                  icon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: emailController,
                validator: (v){
                  if(v == null || v.isEmpty) return "Required EMAIL";
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  icon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: passController,
                obscureText: hidePassword,
                validator: (v){
                  if(v == null || v.isEmpty) return "Required Password";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: (){
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

                  if(_formKey.currentState!.validate()){

                    try {

                      UserCredential userCred =
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passController.text.trim(),
                      );

                      final uid = userCred.user!.uid;

                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .set({
                        "name": nameController.text.trim(),
                        "email": emailController.text.trim(),
                        "createdAt": Timestamp.now(),
                        "isAdmin": false,
                      });


                      final user = UserModel(
                        uid: uid,
                        email: emailController.text.trim(),
                        isAdmin: false,
                      );

                      Provider.of<UserProvider>(context, listen: false)
                          .setUser(user);


                      if(context.mounted){
                        Navigator.pushReplacementNamed(context, "/home");
                      }

                    } catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  }
                },

                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
