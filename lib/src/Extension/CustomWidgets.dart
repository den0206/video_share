import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.height = 50,
    this.width = 200,
    @required this.title,
    this.isLoading = false,
    this.titleColor = Colors.white,
    this.backColor = Colors.green,
    @required this.onPressed,
  }) : super(key: key);
  final double height;
  final double width;

  final String title;
  final bool isLoading;
  final Color titleColor;
  final Color backColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: backColor,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: !isLoading
              ? Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                  ),
                )
              : CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
          onPressed: !isLoading ? onPressed : null),
    );
  }
}

class CustomIcon extends StatelessWidget {
  const CustomIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 27,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 38,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(7)),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 38,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7)),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(7)),
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future showErrorDialog(BuildContext context, error) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Error"),
        content: error.message != null
            ? Text("${error.message} Error")
            : Text("UnknownError"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({
    Key key,
    @required this.child,
    @required this.isLoading,
  }) : super(key: key);

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (isLoading)
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  "Loading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}

class CirculeAnimation extends StatefulWidget {
  final Widget mychild;
  CirculeAnimation(this.mychild);

  @override
  _CirculeAnimationState createState() => _CirculeAnimationState();
}

class _CirculeAnimationState extends State<CirculeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    controller.forward();
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(controller),
      child: widget.mychild,
    );
  }
}
