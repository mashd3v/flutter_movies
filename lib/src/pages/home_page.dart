import 'package:flutter/material.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_landscape.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = new MoviesProvider();
  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopulars();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Text('In Cinema', style: TextStyle(color: Colors.black, fontSize: 25.0)),
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search, color: Colors.black,), onPressed: () {
            showSearch(
              context: context, 
              delegate: DataSearch(),
            );
          })
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_swipeCards(), _footer(context)],
        ),
      ),
    );
  }

  Widget _swipeCards() {
    return FutureBuilder(
      future: moviesProvider.getOnTheaters(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 17.0),
            child: Text('Populars', style: Theme.of(context).textTheme.subtitle1),
          ),
          SizedBox(
            height: 13.0,
          ),
          StreamBuilder(
            stream: moviesProvider.popularsStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieLandscape(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getPopulars,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ]
      ),
    );
  }
}
