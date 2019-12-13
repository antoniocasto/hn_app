import 'dart:async';
import 'dart:collection';

import 'package:http/http.dart' as http;
import 'package:hn_app/src/article.dart';
import 'package:rxdart/rxdart.dart';

class HackerNewsBloc {
  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  HackerNewsBloc() {
    _updateArticles().then((_) {
      _articlesSubject.add(
          UnmodifiableListView(_articles)); //pusha l'attuale lista di articles
    });
  }

  List<int> _ids = [17392995];

  Future<Null> _updateArticles() async {
    final futureArticles = _ids.map((id) => _getArticle(id));

    final articles = await Future.wait(
        futureArticles); //Fatto perche' la map non supporta funzioni anonime asincrone
    _articles = articles;
  }

  Future<Article> _getArticle(int id) async {
    //per scaricare l'articolo
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }
}
