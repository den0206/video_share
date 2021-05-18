import 'package:cached_network_image/cached_network_image.dart';
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
    @required this.icon,
    this.size = 80,
    this.backColor = Colors.white,
    this.borderColor = Colors.black,
    @required this.onPress,
  }) : super(key: key);

  final Icon icon;
  final double size;
  final Color backColor;
  final Color borderColor;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backColor,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: size,
        icon: icon,
        onPressed: onPress,
      ),
    );
  }
}

class CircleCacheAvatar extends StatelessWidget {
  const CircleCacheAvatar({
    Key key,
    @required this.imageUrl,
    this.size = 120,
  }) : super(key: key);

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // border: Border.all(
          //   color: Colors.black,
          //   width: 2,
          // ),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
