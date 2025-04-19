import 'package:flutter/material.dart';

class Fullscreen extends StatelessWidget {
  final String imageURL;

  const Fullscreen({Key? key, required this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_sharp)),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: imageURL,
          child: InteractiveViewer(
            child: Image.network(imageURL),
          ),
        ),
      ),
    );
  }
}
