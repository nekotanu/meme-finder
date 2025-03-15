import 'dart:convert';
import 'package:http/http.dart' as http;

class MemeService {
  Future<List<String>> fetchMemes(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://www.reddit.com/search.json?q=$query&sort=relevance&limit=50'),
    );

    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List posts = data['data']['children'];

      List<String> memes = posts
          .map((post) => post['data']['url_overridden_by_dest']?.toString())
          .where((url) =>
              url != null &&
              (url.endsWith('.jpg') ||
                  url.endsWith('.png') ||
                  url.endsWith('.gif')))
          .cast<String>()
          .toList();

      print(memes);
      return memes;
    } else {
      throw Exception('Failed to load memes');
    }
  }
}
