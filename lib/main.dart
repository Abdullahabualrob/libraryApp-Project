import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/user_provider.dart';
import 'models/user_model.dart';

import 'pages/LoginRegisterPage.dart';
import 'pages/HomePage.dart';
import 'pages/EditBookPage.dart';
import 'pages/MyBorrowedBooksPage.dart';
import 'pages/SignUpPage.dart';
import 'pages/BookDetailsPage.dart';
import 'pages/AddBookPage.dart';
import 'pages/AboutPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: LibraryApp(),
    ),
  );
}

class LibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Library App",
      debugShowCheckedModeBanner: false,

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            final uid = snapshot.data!.uid;

            FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .get()
                .then((doc) {
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
            });

            return const HomePage();
          }

          return const LoginRegisterPage();
        },
      ),

      routes: {
        '/details': (context) => const BookDetailsPage(),
        '/add': (context) => const AddBookPage(),
        '/edit': (context) => const EditBookPage(),
        '/borrowed': (context) => const MyBorrowedBooksPage(),
        '/about': (context) => const AboutPage(),
        '/login': (context) => const LoginRegisterPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
