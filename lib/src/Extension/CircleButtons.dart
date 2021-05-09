import 'package:flutter/material.dart';

class CircleImageButton extends StatelessWidget {
  const CircleImageButton({
    Key key,
    @required this.imageProvider,
    @required this.onTap,
  }) : super(key: key);

  final ImageProvider<Object> imageProvider;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Ink.image(
        image: imageProvider,
        fit: BoxFit.fill,
        width: 120.0,
        height: 120.0,
        child: InkWell(
          onTap: onTap,
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    Key key,
    @required this.onPress,
  }) : super(key: key);

  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: 80,
        icon: Icon(Icons.person),
        onPressed: onPress,
      ),
    );
  }
}
