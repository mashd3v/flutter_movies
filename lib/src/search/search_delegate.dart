import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  final moviesProvider = new MoviesProvider();

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.yellow[700],
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
      textTheme: theme.textTheme.copyWith(
          headline6: theme.textTheme.headline6
              .copyWith(color: theme.primaryTextTheme.headline6.color)),
      accentColor: Colors.yellow[700],
      hoverColor: Colors.white54,
    );
  }

  List<Widget> buildActions(BuildContext context) {
    // AppBar Actions
    return [
      IconButton(
        color: Colors.white,
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Left AppBar Icon
    return IconButton(
        icon: AnimatedIcon(
          color: Colors.white,
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show the results we're going to search
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions
    if (query.isEmpty) {
      return Container(
        padding: EdgeInsets.only(top: 111.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Nothing\'s here, try searching a movie',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 21.0,
                ),
              ),
              SizedBox(
                height: 13.0,
              ),
              Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.grey,
                size: 21.0,
              ),
            ],
          ),
        ),
      );
    }

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Colors.yellow[700],
              child: ListView(
                children: movies.map((movie) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 3.0,
                            // horizontal: 17.0,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 7.0),
                          width: double.infinity,
                          height: 150,
                          child: Stack(
                            children: [
                              FlatButton(
                                onPressed: () {
                                  close(context, null);
                                  movie.uniqueId = '';
                                  Navigator.pushNamed(
                                    context,
                                    'detail',
                                    arguments: movie,
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 17.0),
                                  padding: EdgeInsets.only(left: 110.0),
                                  // color: Colors.white,
                                  width: double.infinity,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Original Title: ${movie.originalTitle}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 13.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                'Rating:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.stars,
                                                    color: Colors.yellow[700],
                                                  ),
                                                  SizedBox(
                                                    width: 3.0,
                                                  ),
                                                  Text(
                                                    movie.voteAverage
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Language:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2,
                                              ),
                                              SizedBox(
                                                height: 7.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      movie.originalLanguage
                                                          .toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1)
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black54,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 27.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(17.0),
                                  child: Image(
                                    image: NetworkImage(movie.getPosterImage()),
                                    height: 150.0,
                                    width: 90.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
