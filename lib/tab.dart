import 'package:flutter/material.dart';
import 'package:meme_finder/memefinder.dart';

class Tab extends StatelessWidget {
  const Tab({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                memes[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Text('Not found'));
                                },
                              ),
                            );,);
  }
}