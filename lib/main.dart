import 'package:flutter/material.dart';
import 'package:meme_finder/memefinder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Meme Finder',
                  style: TextStyle(
                    fontFamily: 'Kw',
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 480,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 171, 211, 231),
                      elevation: 5,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      print('Navigating to Memefinder'); // Debugging
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Memefinder()),
                      );
                    },
                    child: const Text(
                      'Find Memes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
