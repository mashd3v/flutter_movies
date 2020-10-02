import 'package:flutter/material.dart';
import 'package:movies/src/models/cast_model.dart';

class CastLandscape extends StatelessWidget {
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );
  final List<Actor> actor;
  final Function nextPage;

  CastLandscape({@required this.actor, @required this.nextPage});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener(
      () {
        if (_pageController.position.pixels >=
            _pageController.position.maxScrollExtent - 200) {
          nextPage();
        }
      },
    );

    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: actor.length,
        itemBuilder: (context, i) => _card(context, actor[i]),
      ),
    );
  }

  Widget _card(BuildContext context, Actor actor) {
    final actorCard = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: actor.id,
            child: CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/img/loading.gif'),
              child: ClipOval(
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no_image.jpg'),
                  image: NetworkImage(actor.getPhoto()),
                  height: 100.0,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
            textScaleFactor: 0.9,
          )
        ],
      ),
    );

    return GestureDetector(
      child: actorCard,
      onTap: () {
        Navigator.pushNamed(context, 'castDetail', arguments: actor);
      },
    );
  }
}
