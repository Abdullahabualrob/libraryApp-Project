import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final isAdmin = Provider.of<UserProvider>(context,listen:  true).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text(" Library Home"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.red),
              child: Center(
                child: Text(
                  "Library Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.bookmark_added),
              title: const Text("My Borrowed Books"),
              onTap: () => Navigator.pushNamed(context, '/borrowed'),
            ),


            if (isAdmin)
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text("Add Book"),
                onTap: () => Navigator.pushNamed(context, '/add'),
              ),
            ListTile(
             leading: Icon(Icons.info),
             title: Text("About App"),
              onTap: () {
               Navigator.pushNamed(context, '/about');
               },
                ),


    ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                context.read<UserProvider>().clearUser();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('books').snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No books available yet ",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {

              var book = docs[index];
              var data = book.data() ;

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: Colors.red),

                  title: Text(data['title'] ?? "No title"),

                  subtitle: Text(data['author'] ?? "Unknown Author"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/edit',
                              arguments: book,
                            );
                          },
                        ),

                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {

                            final confirm = await showDialog(
                              context: context,
                              builder: (A) => AlertDialog(
                                title:  Text("Delete Book"),
                                content:  Text(
                                    "Are you sure you want to delete this book?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection("books")
                                  .doc(book.id)
                                  .delete();

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text("Book deleted successfully")),
                                );
                              }
                            }
                          },
                        ),

                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),

                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: book,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
