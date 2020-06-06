import 'package:flutter/material.dart';
import 'package:movies/src/models/cast_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _appBar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 9.0,),
                _posterTitle(context, movie),
                _description(context, movie),
                _description(context, movie),
                _description(context, movie),
                _description(context, movie),
                Container(
                  padding: EdgeInsets.only(left: 17.0),
                  child: Text('Cast:', style: Theme.of(context).textTheme.subtitle2),
                ),
                SizedBox(height: 13.0,),
                _cast(movie)
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget _appBar(Movie movie){
    return SliverAppBar(
      elevation: 1.0,
      backgroundColor: Colors.black,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'), 
          image: NetworkImage(movie.getBackgroundImage()),  
          fadeInDuration: Duration(milliseconds:150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Movie movie){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17.0),
              child: Image(
                image: NetworkImage(movie.getPosterImage()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 17.0,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title, style: Theme.of(context).textTheme.headline5, overflow: TextOverflow.ellipsis,),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 13.0,),               
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('Rating:', style: Theme.of(context).textTheme.subtitle2),
                        Row(
                          children: <Widget>[
                            Icon(Icons.star_border),
                            Text(movie.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1)
                          ],
                        )
                      ],
                    ),
                    SizedBox(width: 55.0,),
                    Column(
                      children: <Widget>[
                        Text('Release Date:', style: Theme.of(context).textTheme.subtitle2),
                        Row(
                          children: <Widget>[
                            Text(movie.releaseDate, style: Theme.of(context).textTheme.subtitle1)
                          ],
                        )
                      ],
                    ),
                    SizedBox(width: 30.0,)
                  ],
                ),                
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(BuildContext context, Movie movie){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 17.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyText2
      ),
    );
  }

  Widget _cast(movie){
    final movieProvider = new MoviesProvider();
    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return _actorsPageView(snapshot.data);
        } else{
          return Center(child:CircularProgressIndicator());
        }
      },
    );
  }

  Widget _actorsPageView(List<Actor> actors){
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actors.length,       
        itemBuilder: (context, i) => _actorCard(actors[i]),
      ),
    );
  }

  Widget _actorCard(Actor actor){
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(17.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no_image.jpg'), 
              image: NetworkImage(actor.getPhoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}