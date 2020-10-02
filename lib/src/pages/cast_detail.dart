import 'package:flutter/material.dart';
import 'package:movies/src/models/cast_model.dart';

class CastDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Actor actor = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: Hero(
              tag: actor.id,
              child: Image.network(
                actor.getPhoto(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(17.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  actor.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                  ),
                ),
                SizedBox(
                  height: 11.0,
                ),
                _actorData(
                  characteristic: 'Gender:',
                  data: actor.gender == 1 ? 'Female' : 'Male',
                ),
                SizedBox(
                  height: 11.0,
                ),
                _actorData(
                  characteristic: 'Movie Character:',
                  data: actor.character,
                ),                
              ],
            ),
          ),
          _backButton(context),
        ],
      ),
    );
  }

  Widget _actorData({String characteristic, String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          characteristic,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 19.0,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          data,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19.0,
          ),
        ),
      ],
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
}
