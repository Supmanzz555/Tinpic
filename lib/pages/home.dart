import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tinpic',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 206, 129),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.lightBlue.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center( 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                const SizedBox(height: 40),

                
                const Text(
                  'Welcome to Tinpic!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                
                _buildCustomButton(
                  context,
                  icon: Icons.upload_file,
                  label: 'Upload Your Pics',
                  route: '/upload',
                ),
                const SizedBox(height: 20),

                
                _buildCustomButton(
                  context,
                  icon: Icons.photo_album,
                  label: 'Gallery',
                  route: '/gallery',
                ),
                const SizedBox(height: 20),

                
                _buildCustomButton(
                  context,
                  icon: Icons.swipe,
                  label: 'Let\'s swipe your pics!',
                  route: '/select',
                ),

                const SizedBox(height: 20),
                const Text(
                  'No more boring photo albums!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


  ElevatedButton _buildCustomButton( //template for button layout
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pushNamed(context, route),
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, 
        backgroundColor: Colors.blueAccent, 
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
    );
  }
}
