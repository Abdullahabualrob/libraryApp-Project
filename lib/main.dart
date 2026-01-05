import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

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

  runApp(LibraryApp());
}

class LibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Library App",
      debugShowCheckedModeBanner: false,

      home:
      StreamBuilder<User?>(
        stream:FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {


          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return HomePage();
          }

          return LoginRegisterPage();
        },
      ),

      routes: {
        '/details': (context) => const BookDetailsPage(),
        '/add': (context) => const AddBookPage(),
        '/edit': (context) => const EditBookPage(),
        '/borrowed': (context) => const MyBorrowedBooksPage(),
        '/about': (context) => const AboutPage(),
        '/login':(context)=> const LoginRegisterPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
