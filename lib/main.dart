import 'package:flutter/material.dart';
import 'package:meme_finder/api.dart';
import 'package:meme_finder/fullscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF1E1E1E),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController memefinder = TextEditingController();
  List<String> memes = [];
  bool isLoading = false;
  int selectedTabIndex = 0;

  final List<Map<String, dynamic>> trendingCategories = [
    {'text': '#DANKMEMES', 'color': const Color(0xFFFF6B9D)},
    {'text': '#RELATABLE', 'color': const Color(0xFF5D9CFF)},
    {'text': '#DARKHUMOR', 'color': const Color(0xFFA45DFF)},
    {'text': '#WHOLESOME', 'color': const Color(0xFF5DFF8E)},
  ];

  final MemeService memeService = MemeService();

  void searchRedditMemes(String query) async {
    setState(() => isLoading = true);
    try {
      final result = await memeService.fetchMemes(query);
      setState(() {
        memes = result;
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load memes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    searchRedditMemes(trendingCategories[0]['text'].replaceAll('#', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Header with gradient text
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFF5D9CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Column(
                  children: [
                    Text(
                      'LOST IN THE WORLD?',
                      style: TextStyle(
                        fontFamily: 'Bungee',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FIND MEMES FASTER!',
                      style: TextStyle(
                        fontFamily: 'Bungee',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search field with glassmorphism effect
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextField(
                  controller: memefinder,
                  onSubmitted: (_) => searchRedditMemes(memefinder.text),
                  cursorColor: const Color(0xFF5D9CFF),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    suffixIcon: const Icon(Icons.search, color: Colors.white70),
                    hintText: 'Type your meme... hit enter',
                    hintStyle: TextStyle(
                      fontFamily: 'LuckiestGuy-Regular',
                      color: Colors.white.withOpacity(0.7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF5D9CFF),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Trending tabs with smooth animation
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingCategories.length,
                  itemBuilder: (context, index) {
                    final category = trendingCategories[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        gradient: selectedTabIndex == index
                            ? LinearGradient(
                                colors: [
                                  category['color'],
                                  category['color'].withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: category['color'],
                          width: selectedTabIndex == index ? 0 : 2,
                        ),
                        boxShadow: selectedTabIndex == index
                            ? [
                                BoxShadow(
                                  color: category['color'].withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          setState(() {
                            selectedTabIndex = index;
                          });
                          searchRedditMemes(
                              category['text'].replaceAll('#', ''));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Text(
                            category['text'],
                            style: TextStyle(
                              fontFamily: 'Bungee',
                              fontSize: 14,
                              color: selectedTabIndex == index
                                  ? Colors.white
                                  : category['color'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Meme grid with shimmer loading effect
              Expanded(
                child: isLoading
                    ? _buildShimmerGrid()
                    : memes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sentiment_dissatisfied,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No memes found!',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: memes.length,
                            itemBuilder: (BuildContext context, int index) {
                              final memeUrl = memes[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Fullscreen(imageURL: memeUrl),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: memeUrl,
                                    child: Image.network(
                                      memeUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[800],
          ),
        );
      },
    );
  }
}
