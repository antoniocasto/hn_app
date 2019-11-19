class Article {
  final String text;
  final String url;
  final String by;
  final String age;
  final int score;
  final int commentsCount;

  const Article(
      {this.text, this.url, this.by, this.age, this.score, this.commentsCount});

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
        age: json['age'] ?? 0,
        score: json['score']);
  }
}

final articles = [
  Article(
    text: "Juventus wins the game.",
    url: "Juventus.com",
    by: "jvvv",
    age: "25",
    score: 177,
    commentsCount: 62,
  ),
  Article(
    text: "Milan wins the game.",
    url: "Milan.com",
    by: "jvvv",
    age: "25",
    score: 33,
    commentsCount: 22,
  ),
  Article(
    text: "Inter winsxxxx the game.",
    url: "Inter.com",
    by: "jvvv",
    age: "25",
    score: 1,
    commentsCount: 1,
  ),
  Article(
    text: "Inter winscccc the game.",
    url: "Inter.com",
    by: "jvvv",
    age: "25",
    score: 1,
    commentsCount: 1,
  ),
  Article(
    text: "Inter winsvvvv the game.",
    url: "Inter.com",
    by: "jvvv",
    age: "25",
    score: 1,
    commentsCount: 1,
  ),
  Article(
    text: "Inter winsbbbb the game.",
    url: "Inter.com",
    by: "jvvv",
    age: "25",
    score: 1,
    commentsCount: 1,
  ),
  Article(
    text: "Inter winsnnnnn the game.",
    url: "Inter.com",
    by: "jvvv",
    age: "25",
    score: 1,
    commentsCount: 1,
  ),
  Article(
    text: "Inter winsmmmm the game.",
    url: "Inter.com",
    by: "jvvv",
    age: "25",
    score: 1,
    commentsCount: 1,
  ),
  Article(
    text: "Inter wins,,,, the game.",
    url: "Inter.com",
    by: "jvvv",
    age: "25",
    score: 1,
    commentsCount: 1,
  ),
];
