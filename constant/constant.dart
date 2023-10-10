import 'package:flutter/material.dart';

class Constant {
  static const TextStyle categoryHeading = TextStyle(color: Colors.black,fontWeight:FontWeight.w500 );
  static const double BORDER_RADIUS = 10;
  static const double BORDER_RADIUS_MIDDLE = 14;

  static const double BORDER_RADIUS_HIGH = 20;
  static const double MARGIN_WIDTH = 36;

  static const Color WHITE = Color(0xffffffff);
  static const Color PRIMARY_BLACK = Color(0xff202020);
  static const Color BLACK = Color(0xff000000);

  static const Color lOW_BLACK = Color(0xff373737);
  static const Color LIGHT_BLACK = Color(0xffa2a2a2);
  static const Color SHADOW_COLOR = Color(0xff26000000);

  static const Color FILLCOLOR = Color(0xfff2f2f2);
  static const FontWeight FONT_WEIGHT_SEMI_BOLD = FontWeight.w600;
  static const FontWeight FONT_WEIGHT_MEDIUM = FontWeight.w500;
  static const TextStyle NAME_STYLE = TextStyle(
    color: Constant.PRIMARY_BLACK,
    fontSize: 16,
  );
}

TextStyle nameStyle = Constant.NAME_STYLE;

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key, required this.text, this.onPressed})
      : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    // margin: EdgeInsets.only(left: 36, right: 36),
    //   height: 50,
    //   decoration: BoxDecoration(
    //     color: Constant.PRIMARY_BLACK,
    //     borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
    //   ),
    //   alignment: Alignment.center,
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: Constant.PRIMARY_BLACK,
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          shape: const StadiumBorder()),
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: Constant.FONT_WEIGHT_MEDIUM,
            fontSize: 18,
            color: Constant.WHITE),
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 6,
      ),
      height: 44,
      width: 44,
      // constraints: BoxConstraints(maxWidth: 44),

      decoration: BoxDecoration(
        color: Constant.PRIMARY_BLACK,
        borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.arrow_back_ios,
        color: Constant.WHITE,
        // size: 30.0,
      ),
    );
  }
}
