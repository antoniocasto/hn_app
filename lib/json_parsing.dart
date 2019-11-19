import 'dart:convert' as json;

class Article {
  final String text;
  final String url;
  final String by;
  final int timestamp;
  final int score;

  const Article({this.text, this.url, this.by, this.timestamp, this.score});

  factory Article.fromJson(Map<String, dynamic> json) {
    //Costruttore alternativo
    if (json == null) {
      return null;
    }

    return Article(
        text: json['text'] ??
            "[null]", // ?? e' un operatore ternario. Se il valore non c'e mette quello che gli indico
        url: json['url'],
        by: json['by'],
        timestamp: json['age'] ?? 0,
        score: json['score']);
  }
}

List<int> parseTopStories(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  final listOfIds = List<int>.from(parsed);
  return listOfIds;
}

Article parseArticle(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  Article article = Article.fromJson(parsed);
  return article;
}
