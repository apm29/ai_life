import 'package:flutter/material.dart';

typedef PressCallback = Future<void> Function();

const Gradient _kDefaultGradient = const LinearGradient(
  colors: [Colors.purple, Colors.lightBlue],
);

class GradientButton extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  final PressCallback onPressed;

  GradientButton(
    this.child, {
    this.gradient = _kDefaultGradient,
    @required this.onPressed,
  }) : assert(onPressed != null);

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _loading = false;
  final int _kDelayMilli = 1000;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
          decoration: BoxDecoration(
              gradient: widget.gradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[500],
                  offset: Offset(0.0, 1.5),
                  blurRadius: 1.5,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(3))),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: _loading
                    ? null
                    : () async {
                        if (_loading) {
                          return null;
                        }
                        startLoading();
                        return widget.onPressed.call().then((_) {
                          Future.delayed(Duration(milliseconds: _kDelayMilli))
                              .then((_) {
                            stopLoading();
                          });
                        }).catchError((e) {
                          stopLoading();
                        });
                      },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    IgnorePointer(
                      ignoring: _loading,
                      child: Opacity(
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          child: Container(
                            child: widget.child,
                            constraints:
                                BoxConstraints(minHeight: 32.0, minWidth: 72.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                          ),
                        ),
                        opacity: _loading ? 0 : 1,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 16.0,
                        maxWidth: 16.0,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Visibility(
                          visible: _loading,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          )),
    );
  }

  void stopLoading() {
    setState(() {
      _loading = false;
    });
  }

  void startLoading() {
    setState(() {
      _loading = true;
    });
  }
}
