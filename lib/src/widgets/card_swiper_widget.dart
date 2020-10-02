import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;
  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.5,
      child: Swiper(
        layout: SwiperLayout.CUSTOM,
        duration: 800,
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.45,
        itemBuilder: (BuildContext context, int index) {
          movies[index].uniqueId = '${movies[index].id}-card';
          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  'detail',
                  arguments: movies[index],
                ),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'),
                  image: NetworkImage(movies[index].getPosterImage()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
        customLayoutOption: new CustomLayoutOption(
          startIndex: -1,
          stateCount: 3,
        ).addRotate([-40.0 / 180, 0.0, 40.0 / 180]).addTranslate(
          [
            new Offset(-280.0, -45.0),
            new Offset(0.0, 0.0),
            new Offset(280.0, -45.0),
          ],
        ),
      ),
    );
  }
}
