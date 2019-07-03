import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class NotFoundPage extends StatefulWidget {
  final String routeName;

  const NotFoundPage({Key key, this.routeName}) : super(key: key);

  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PageNotFound"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FlareActor(
                "flr/Space Demo.flr",
                alignment: Alignment.center,
                fit: BoxFit.cover,
                animation: "loading",
              ),
            ),
            Container(
              padding: EdgeInsets.all(18),
              child: Text(
                "404\nPAGE NOT FOUND \nRoute Name: ${widget.routeName}\r\nThe Page is not on the Earth",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
