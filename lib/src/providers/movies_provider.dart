import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/src/models/cast_model.dart';
import 'package:movies/src/models/movie_model.dart';

class MoviesProvider {
  String _apikey = '2bc6c3b15d1a1d310e49b17228d5d706';
  String _url = 'api.themoviedb.org';
  String _language = 'en-US';
  int _pagePopulars = 0;
  bool _loading = false;
  List<Movie> _populars = new List();
  final _popularsStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get pupularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> _getResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final movies = new Movies.fromJsonList(decodedData['results']);
    return movies.items;
  }

  Future<List<Movie>> getOnTheaters() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey, 
      'language': _language
      });
    return await _getResponse(url);
  }

  Future<List<Movie>> getPopulars() async {
    if (_loading) return [];
    _loading = true;
    _pagePopulars++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _pagePopulars.toString()
    });
    final ans = await _getResponse(url);
    _populars.addAll(ans);
    pupularsSink(_populars);
    _loading = false;
    return ans;
  }

  Future<List<Actor>> getCast(String movieId) async{
    final url = Uri.https(_url, '3/movie/$movieId/credits',{
      'api_key': _apikey,
      'language': _language,
    });
    final ans = await http.get(url);
    final decodedData = json.decode(ans.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apikey, 
      'language': _language,
      'query': query
    });
    return await _getResponse(url);
  }

}
