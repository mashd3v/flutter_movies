import 'package:flutter/material.dart';
import 'package:movies/src/models/cast_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/widgets/cast_landscape.dart';

class MovieDetail extends StatelessWidget {
  final actor = new Actor();
  final movieProvider = new MoviesProvider();
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              _backgroundPoster(movie),
              _movieInfo(context, movie),
              _mainPoster(movie),
              _backButton(context),
            ],
          ),
          SizedBox(
            height: 23.0,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Colors.yellow[700],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 17.0),
                            child: Text(
                              'Introduction',
                              style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _description(context, movie),
                          _description(context, movie),
                        ],
                      ),
                      SizedBox(
                        height: 27.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 17.0),
                            child: Text(
                              'Cast',
                              style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13.0,
                          ),
                          _footer(context, actor, movie),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundPoster(Movie movie) {
    return Container(
      height: 230.0,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Image(
          image: NetworkImage(movie.getBackgroundImage()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _mainPoster(Movie movie) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 170.0, 0.0, 0.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17.0),
        child: Hero(
          tag: movie.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17.0),
            child: Image(
              image: NetworkImage(movie.getPosterImage()),
              height: 150.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _movieInfo(BuildContext context, Movie movie) {
    return Padding(
      padding: EdgeInsets.only(top: 190),
      child: Container(
        // color: Colors.white,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 2.0),
              blurRadius: 5.0,
            ),
          ],
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(130.0, 10.0, 5.0, 0.0),
        height: 130.0,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: Theme.of(context).textTheme.headline5,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Original Title: ${movie.originalTitle}',
              style: Theme.of(context).textTheme.subtitle1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 13.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Rating:',
                      style: Theme.of(context).textTheme.subtitle2,
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
                          movie.voteAverage.toString(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Release Date:',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          movie.releaseDate,
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Language:',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text(movie.originalLanguage.toUpperCase(),
                            style: Theme.of(context).textTheme.subtitle1)
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 40.0,
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _description(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 17.0,
          ),
          Text(
            movie.overview,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, Actor actor, Movie movie) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5.0),
          FutureBuilder(
            future: movieProvider.getCast(movie.id.toString()),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return CastLandscape(
                  actor: snapshot.data,
                  nextPage: movieProvider.getCast,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
