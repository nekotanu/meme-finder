import 'package:flutter/material.dart';
import 'package:meme_finder/api.dart';

class Memefinder extends StatefulWidget {
  const Memefinder({super.key});

  @override
  State<Memefinder> createState() => _MemefinderState();
}

class _MemefinderState extends State<Memefinder> {
  TextEditingController textEditingController = TextEditingController();
  List<String> memes = [];
  bool isLoading = false;
  final MemeService memeService = MemeService();

  void searchMeme() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await memeService.fetchMemes(textEditingController.text);
      setState(() {
        memes = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              autocorrect: true,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Find your memes here',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (_) => searchMeme(),
            ),
            SizedBox(height: 12),
            isLoading
                ? CircularProgressIndicator()
                : memes.isEmpty
                    ? Text("No memes found")
                    : Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 3 / 2,
                          ),
                          itemCount: memes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  filterQuality: FilterQuality.high,
                                  memes[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(child: Text('Not found'));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
