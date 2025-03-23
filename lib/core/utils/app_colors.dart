import 'package:flutter/material.dart';

import 'hex_color.dart';

class AppColors {
  static Color primary = HexColor('#A05A8C');
  static Color primaryText = HexColor('#373737');
  static Color primaryColor = HexColor('#A05A8C');
  static Color secondPrimary = HexColor('#1E487F');
  static Color blue = HexColor('#A05A8C');
   static Color orange = HexColor('#1E487F');
   static Color secondry = HexColor('#734A68');
  static Color orangeThirdPrimary = HexColor('#8F8F8F');
  static Color blueLiteColor = HexColor('#00B3DC');
  static Color blueTextColor = HexColor('#5663FF');
  static Color grayTextColor = HexColor('#6E7FAA');
  static Color goldStarColor = HexColor('#FFCC00');
  static Color unStarColor = HexColor('#E9E9EE');
  static Color scaffoldColor = HexColor('#F5F5F5');
  static Color avatarColor = HexColor('#96B2B5');
  static Color purpelColor = HexColor('#9C45E0');
  static Color primaryHint = HexColor('#B2B2B2');
  static Color primaryGrey = HexColor('#525252');
  static Color hint = Colors.grey;
  static Color blackLite = Colors.black54;
  static Color error = Colors.red;
  static Color success = Colors.green;
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color gray = Colors.grey;
  static Color grayLite = Colors.grey[700]!;
  static Color gray1 = HexColor('#D3D3D3');
  static Color gray2 = HexColor('#225862');

  static Color red = HexColor('#FF0000');
  static Color blue3 = const Color(0xff3646ff);
  static Color greyColor = const Color(0xffB2B2B2);

  static Color grey2Color = const Color(0xffEFEFEF);
  static Color yellowColor = const Color(0xffFF9201);
  static Color bink = HexColor('#FF9F9F');
  static Color purple1 = HexColor('#854AA4');
  static Color purple1light = HexColor('#E3D2FE');

  static Color blue1 = HexColor('#CBDFF8');
  static Color blue2 = HexColor('#8290F8');
  static Color blue4 = const Color(0xff3E3F68);
  static Color bluelight = HexColor('#D7EAF9');
 
  static Color orangeLight = HexColor('#FF9201');
  static Color orangelight = HexColor('#FFEAD7');
  static Color green = HexColor('#01880A');
  static Color opacityWhite = Colors.white.withOpacity(0.5);
  static Color transparent = Colors.transparent;

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lightens(String color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(HexColor(color));
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
