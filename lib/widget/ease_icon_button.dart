import 'package:flutter/material.dart';

const colorList = [
  Color(0x668900a1),
  Color(0x666c15b6),
  Color(0x663d52c9),
  Color(0x661d7ae1),
  Color(0x661496f1),
  Color(0x661496f1),
  Color(0x661496f1),
  Color(0x661496f1),
  Color(0x661496f1),
  Color(0x661496f1),
];

class EaseIconButton extends StatelessWidget {
  final index;
  final text;
  final VoidCallback onPressed;
  final IconData icon;

  EaseIconButton(this.index, this.text, this.onPressed, this.icon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: colorList[index + 1],
      borderRadius: BorderRadius.horizontal(left: Radius.circular(100),right: Radius.circular(100)),
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width/5
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colorList.sublist(index, index + 2),
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: colorList[index].withAlpha(0xcf),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: colorList[index].withBlue(0xff).withAlpha(0xa1),
                fontFamily: "Determination",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
