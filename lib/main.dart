import 'package:flutter/material.dart';
import 'src/article.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _ids = [17392995];

  Future<Article> _getArticle(int id) async {
    //per scaricare l'articolo
    final storyUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final storyRes = await http.get(storyUrl);
    if (storyRes.statusCode == 200) {
      return parseArticle(storyRes.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _ids
            .map(
              (i) => FutureBuilder<Article>(
                future: _getArticle(
                    i), //oggetto che verra ricevuto come Future<oggetto>
                builder: //come viene buildato nel tree
                    (BuildContext context, AsyncSnapshot<Article> snapshot) {
                  //snapshot e' il nuovo dato ricevuto
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _buildItem(snapshot.data);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildItem(Article article) {
    return Padding(
      key: Key(article.title),
      padding: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          article.title ?? '[null]',
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                article.type,
              ),
              IconButton(
                icon: Icon(Icons.launch),
                onPressed: () async {
                  if (await canLaunch(article.url)) {
                    launch(article.url);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
