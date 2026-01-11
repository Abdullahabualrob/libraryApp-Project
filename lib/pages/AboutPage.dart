import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Library App"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Image.network(
                  "https://images.pexels.com/photos/256541/pexels-photo-256541.jpeg",
                  height: 200,
                  width: 600,
                  fit: BoxFit.cover,
                ),


              SizedBox(height: 25), Icon(Icons.local_library, size: 100, color: Colors.red,),

               SizedBox(height: 20),

               Text("Library Management App", style: TextStyle(fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

             SizedBox(height: 12),

             Text("This application allows users to browse books, borrow them, "
                    "and manage borrowed books easily using Flutter and Firebase.", textAlign: TextAlign.center,
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
              ),

             SizedBox(height: 30),


              Text("Developed By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
              ),
              SizedBox(height: 16),

              Text("Abdullah AbuAlrob",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),

              Text("Ayman Aleliat",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),

              Text("Ahmed Alkirim",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),

              const SizedBox(height: 30),


              const Text("Version 1.0", style: TextStyle(color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
