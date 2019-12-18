import 'dart:async';
import 'dart:collection';

import 'package:http/http.dart' as http;
import 'package:hn_app/src/article.dart';
import 'package:rxdart/rxdart.dart';

enum StoriesType { topStories, newStories }

class HackerNewsApiError extends Error {
  final String message;

  HackerNewsApiError(this.message);
}

class HackerNewsBloc {
  HashMap<int, Article>
      _cachedArticles; //Creo una cache per gli articoli cosi velocizzo l'app

  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  final _isLoadingSubject = BehaviorSubject<
      bool>(); //Dopo la sottoscrizione mi fornisce il valore piu recente

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _storiesTypeController = StreamController<StoriesType>();

  HackerNewsBloc() {
    _cachedArticles = HashMap<int, Article>();
    _initializeArticles(); //trucco per usare async e await all'interno di un costruttore o funzione non asincrono

    _storiesTypeController.stream.listen((storiesType) async {
      _getArticlesAndUpdate(await _getIds(storiesType));
    });
  }

  Future<void> _initializeArticles() async {
    _getArticlesAndUpdate(await _getIds(StoriesType.topStories));
  }

  void close() {
    _storiesTypeController.close();
  }

  Future<List<int>> _getIds(StoriesType type) async {
    final partUrl = type == StoriesType.topStories ? 'top' : 'new';
    final url = '$_baseUrl${partUrl}stories.json';
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw HackerNewsApiError('Stories $type couldn\'t be fetched.');
    }
    return parseTopStories(response.body).take(10).toList();
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  Future<Null> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds.map((id) => _getArticle(id));

    final articles = await Future.wait(
        futureArticles); //Fatto perche' la map non supporta funzioni anonime asincrone
    _articles = articles;
  }

  Future<Article> _getArticle(int id) async {
    //per scaricare l'articolo

    if (!_cachedArticles.containsKey(id)) {
      //Se l'articolo di cui ricevo l'id non e' cachato, lo scarico nuovamente
      final storyUrl = '${_baseUrl}item/$id.json';
      final storyRes = await http.get(storyUrl);
      if (storyRes.statusCode == 200) {
        _cachedArticles[id] = parseArticle(storyRes.body);
      } else {
        throw HackerNewsApiError('Article $id couldn\'t be fetched.');
      }
    }
    return _cachedArticles[id];
  }

  _getArticlesAndUpdate(List<int> ids) async {
    _isLoadingSubject.add(true);
    await _updateArticles(ids);
    _articlesSubject.add(UnmodifiableListView(_articles));
    _isLoadingSubject.add(false);
  }
}
