import 'dart:async';
import 'dart:collection';

import 'package:http/http.dart' as http;
import 'package:hn_app/src/article.dart';
import 'package:rxdart/rxdart.dart';

enum StoriesType { topStories, newStories }

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _storiesTypeController = StreamController<StoriesType>();

  HackerNewsBloc() {
    _storiesTypeController.stream.listen((storiesType) {
      if (storiesType == StoriesType.newStories) {
        _getArticlesAndUpdate(_newIds);
      } else {
        _getArticlesAndUpdate(_topIds);
      }
    });
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  static List<int> _newIds = [
    17395675,
    17387438,
    17393560,
    17391971,
    17392455,
  ];

  static List<int> _topIds = [
    17392995,
    17397852,
    17395342,
    17385291,
    17387851,
    17395675,
    17387438,
    17393560,
    17391971,
    17392455,
  ];

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  final _isLoadingSubject = BehaviorSubject<
      bool>(); //Dopo la sottoscrizione mi fornisce il valore piu recente

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));

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

  _getArticlesAndUpdate(List<int> ids) async {
    _isLoadingSubject.add(true);
    await _updateArticles(ids);
    _articlesSubject.add(UnmodifiableListView(_articles));
    _isLoadingSubject.add(false);
  }
}
