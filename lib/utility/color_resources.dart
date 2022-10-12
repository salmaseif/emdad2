import 'package:flutter/material.dart';
import 'package:emdad/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {

  static Color getColombiaBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF678cb5) : Color(0xFF92C6FF);
  }
  static Color getLightSkyBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFc7c7c7) : Color(0xFF8DBFF6);
  }
  static Color getHarlequin(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF257800) : Color(0xFF3FCC01);
  }
  static Color getCheris(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF941546) : Color(0xFFE2206B);
  }
  static Color getTextTitle(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFF212629);
  }

  static Color getGrey(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF808080) : Color(0xFFF1F1F1);
  }
  static Color getRed(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF7a1c1c) : Color(0xFFFF5555);
  }
  static Color getYellow(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF916129) : Color(0xFFFFAA47);
  }
  static Color getHint(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFc7c7c7) : Color(0xFF9E9E9E);
  }
  static Color getGainsBoro(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF999999) : Color(0xFFE6E6E6);
  }
  static Color getTextBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF414345) : Color(0xFFF8FBFD);
  }
  static Color getIconBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF2e2e2e) : Color(0xFFF9F9F9);
  }
  static Color getHomeBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF3d3d3d) : Color(0xFFFCFCFC);
  }
  static Color getImageBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF3f4347) : Color(0xFFE2F0FF);
  }
  static Color getSellerTxt(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF517091) : Color(0xFF92C6FF);
  }
  static Color getChatIcon(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFebebeb) : Color(0xFFD4D4D4);
  }
  static Color getLowGreen(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF7d8085) : Color(0xFFEFF6FE);
  }
  static Color getGreen(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF167d3c) : Color(0xFF23CB60);
  }
  static Color getFloatingBtn(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF49698c) : Color(0xFF7DB6F5);
  }
  static Color getPrimary(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFf0f0f0) : Theme.of(context).primaryColor;
  }
  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF585a5c) : Color(0xFFF4F7FC);
  }
  static Color getArrowButtonColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFBE8551) : Color(0xFFFE8551);
  }
  static Color getReviewRattingColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFF4F7FC) : Color(0xFF66717C);
  }
  static Color visitShop(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFF4F7FC) : Color(0xFFF3F5F9);
  }

  static Color couponColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFC8E4FF) : Color(0xFFC8E4FF);
  }


  static const Color BLACK = Color(0xFF645BC4);
  static const Color WHITE = Color(0xffFFFFFF);
  static const Color LIGHT_SKY_BLUE = Color(0xff8DBFF6);
  static const Color HARLEQUIN = Color(0xff3FCC01);
  static const Color CERISE = Color(0xffE2206B);
  static const Color GREY = Color(0xffF1F1F1);
  static const Color RED = Color(0xFFD32F2F);
  static const Color YELLOW = Color(0xFFFFAA47);
  static const Color HINT_TEXT_COLOR = Color(0xff9E9E9E);
  static const Color GAINS_BORO = Color(0xffE6E6E6);
  static const Color TEXT_BG = Color(0xffF3F9FF);
  static const Color ICON_BG = Color(0xffF9F9F9);
  static const Color HOME_BG = Color(0xffF0F0F0);
  static const Color IMAGE_BG = Color(0xffE2F0FF);
  static const Color SELLER_TXT = Color(0xff92C6FF);
  static const Color CHAT_ICON_COLOR = Color(0xffD4D4D4);
  static const Color LOW_GREEN = Color(0xffEFF6FE);
  static const Color GREEN = Color(0xff23CB60);


  static Color getBlue(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF007ca3) : Color(0xFF00ADE3);
  }

  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF6f7275) : Color(0xFFA0A4A8);
  }

  static Color getWhite(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
  }

  static Color getPrimaryColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFba4f41) : Color(0xFFFC6A57);
  }

  static Color getBottomSheetColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF25282B) : Color(0xFFF4F7FC);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF98a1ab) : Color(0xFF52575C);
  }

  static Color getSubTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFA0A0A0) : Color(0xFFA0A0A0);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }

  static Color getTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFE4E8EC) : Color(0xFF25282B);
  }

  static const Color primaryColor = Color(0xFF645BC4);
  // static const primaryColor = Color(0xFF4CAF50);
  static const Color primaryLightColor = Color(0xFFE8F5E9);
  static const Color COLOR_BLUE = Color(0xff00ADE3);
  static const Color COLUMBIA_BLUE = Color(0xff00ADE3);
  static const Color YELLOWS = Color(0xFF916129);
  static const Color FLOATING_BTN = Color(0xff7DB6F5);
  static const Color COLOR_LIGHT_BLACK = Color(0xFF4A4B4D);
  static const Color COLOR_HINT = Color(0xFF52575C);
  static const Color DISABLE_COLOR = Color(0xFF979797);

  static const Color COLOR_PRIMARY = Color(0xFF645BC4);
  static const Color COLOR_DODGER_BLUE = Color(0xff0086FC);
  static const Color COLOR_PRIMARY_DARK = Color(0xff4D49E1);
  static const Color COLOR_MARINER = Color(0xff3B5998);
  static const Color COLOR_BLACK = Color(0xff000000);
  static const Color COLOR_NERO = Color(0xff1A1A1A);
  static const Color COLOR_BITTERSWEET = Color(0xffFF6761);
  static const Color COLOR_GRAY = Color(0xff707070);
  static const Color COLOR_GRAY_CHATEAU = Color(0xff959CA7);
  static const Color COLOR_WHITE = Color(0xffFFFFFF);
  static const Color COLOR_CONFLOWER_BLUE = Color(0xff548CF6);
  static const Color COLOR_ROYAL_BLUE = Color(0xff5554DA);
  static const Color COLOR_SIMPLE_BLUE = Color(0xffA6C3FB);
  static const Color COLOR_RED = Color(0xffED1C24);
  static const Color COLOR_GREY = Color(0xff707070);
  static const Color COLOR_GREY2 = Color(0xff727272);
  static const Color COLOR_GREY3 = Color(0xffACACAC);
  static const Color COLOR_ALTO = Color(0xffC9C0C0);
  static const Color COLOR_SILVER = Color(0xffB8B8B8);
  static const Color COLOR_YELLOW_SEA = Color(0xffF5963E);
  static const Color COLOR_MOUNTAIN_MEADOW = Color(0xff129A7F);
  static const Color COLOR_DEEP_SEA = Color(0xff109178);
  static const Color COLOR_MEDIUM_SLATE_BLUE = Color(0xffA079EC);
  static const Color COLOR_SPECIALIST_CARD_PRICE = Color(0xffFDBD83);
  static const Color COLOR_HOME_BACKGROUND = Color(0xffF6F6F6);
  static const Color COLOR_GAINSBORO = Color(0xffDBDBDB);
  static const Color COLOR_MAYA_BLUE = Color(0xff3ECDFF);
  static const Color COLOR_COLUMBIA_BLUE = Color(0xffB1D8FA);
  static const Color COLOR_SKY_MAYA_BLUE = Color(0xffD6ECFF);

  static const Color COLOR_LIGHT_WHITE = Color(0xffF8F8F8);
  static const Color COLOR_LIGHT_GREY = Color(0xffEDEDED);
  static const Color FIRST_COLOR = Color(0xff68BDD2);
  static const Color SECOND_COLOR = Color(0xff9BD8D0);
  static const Color THIRD_COLOR = Color(0xffA5E8FF);
  static const Color FOURTH_COLOR = Color(0xffB3F8B9);
  static const Color FIFTH_COLOR = Color(0xffD9B0FF);
  static const Color SIXTH_COLOR = Color(0xff95E8DE);
  static const Color white = Color.fromRGBO(255,255,255, 1);
  static const Color lightGrey = Color.fromRGBO(239,239,239, 1);
  static const Color darkGrey = Color.fromRGBO(112,112,112, 1);
  static const Color mediumGrey = Color.fromRGBO(132,132,132, 1);
  static const Color grey_153 = Color.fromRGBO(153,153,153, 1);
  static const Color fontGrey = Color.fromRGBO(22, 29, 50, 1);
  static const Color textFieldGrey = Color.fromRGBO(209,209,209, 1);
  static const Color golden = Color.fromRGBO(248, 181, 91, 1);
  static const Color mediumGrey_50 = Color.fromRGBO(132,132,132, .5);
  static const Color appColorPrimary = Color(0xFF1157FA);
  static const Color appColorAccent = Color(0xFF03DAC5);
  static const Color appTextColorPrimary = Color(0xFF212121);
  static const Color iconColorPrimary = Color(0xFFFFFFFF);
  static const Color appTextColorSecondary = Color(0xFF5A5C5E);
  static const Color iconColorSecondary = Color(0xFFA8ABAD);
  static const Color appLayoutBackground = Color(0xFFf8f8f8);
  static const Color appLightPurple = Color(0xFFdee1ff);
  static const Color appLightOrange = Color(0xFFffddd5);
  static const Color appLightParrotGreen = Color(0xFFb4ef93);
  static const Color appIconTintCherry = Color(0xFFffddd5);
  static const Color appIconTintSkyBlue = Color(0xFF73d8d4);
  static const Color appIconTintMustardYellow = Color(0xFFffc980);
  static const Color appIconTintDarkPurple = Color(0xFF8998ff);
  static const Color appTxtTintDarkPurple = Color(0xFF515BBE);
  static const Color appIconTintDarkCherry = Color(0xFFf2866c);
  static const Color appIconTintDarkSkyBlue = Color(0xFF73d8d4);
  static const Color appDarkParrotGreen = Color(0xFF5BC136);
  static const Color appDarkRed = Color(0xFFF06263);
  static const Color appLightRed = Color(0xFFF89B9D);
  static const Color appCat1 = Color(0xFF8998FE);
  static const Color appCat2 = Color(0xFFFF9781);
  static const Color appCat3 = Color(0xFF73D7D3);
  static const Color appCat4 = Color(0xFF87CEFA);
  static const Color appCat5 = appColorPrimary;
  static const Color appShadowColor = Color(0x95E9EBF0);
  static const Color appColorPrimaryLight = Color(0xFFF9FAFF);
  static const Color appSecondaryBackgroundColor = Color(0xFF131d25);
  static const Color appDividerColor = Color(0xFFDADADA);
  static const Color  barber = Color(0xFFD1870B);
  static const Color  barber2 = Color(0xFF9B7C3D);
  static const Color  barber3 = Color(0xFFD7B56F);
  static const Color  barber4 = Color(0xFFBC8514);
  static const Color  bellCommerce = Color(0xFF40BFFF);
  static const Color  food = Color(0xFFFF0303);
  static const Color  furn = Color(0xFF5866A4);
  static const Color  rest = Color(0xFFFFEBA1);
  static const Color  shu = Color(0xFFF6402E);
  static const Color  treShop = Color(0xFFFC8080);
// Dark Theme Colors
  static const Color appBackgroundColorDark = Color(0xFF121212);
  static const Color cardBackgroundBlackDark = Color(0xFF1F1F1F);
  static const Color colorPrimaryBlack = Color(0xFF131d25);
  static const Color appColorPrimaryDarkLight = Color(0xFFF9FAFF);
  static const Color iconColorPrimaryDark = Color(0xFF212121);
  static const Color iconColorSecondaryDark = Color(0xFFA8ABAD);
  static const Color appShadowColorDark = Color(0x1A3E3942);
  static const Color  background = Color(0xFFFFFFFF);
  static const Color  card = Color(0xFFF8F8F8);
  static const Color  fontTitle = Color(0xFF202020);
  static const Color  fontSubtitle = Color(0xFF737373);
  static const Color  fontDisable = Color(0xFF9B9B9B);
  static const Color  disabledButton = Color(0xFFB9B9B9);
  static const Color  divider = Color(0xFFDCDCDC);
  static const Color  success = Color(0xFF388E3C);
  static const Color  warning = Color(0xFFF57C00);
  static const Color  error = Color(0xFFD32F2F);
  static const Color  info = Color(0xFFB6985B);

  static const Color COLOR_DIM_GRAY = Color(0xff6D6D6D);
  static const Color COLOR_VERY_LIGHT_GRAY = Color(0xffCFCFCF);
  static const Color COLOR_LIGHT_GRAY = Color(0xffDDE0ED);
  static const Color COLOR_PANACHE = Color(0xffE9F6DB);
  static const Color COLOR_Lavender = Color(0xffF5F8FD);
  static const Color COLOR_WHITE_GRAY = Color(0xffE6E6E6);
  static const Color COLOR_GHOST_WHITE = Color(0xffF2F2FF);
  static const Color COLOR_HAWKES_BLUE = Color(0xffF7F6FB);
  static const Color COLOR_WHITE_SMOKE = Color(0xffF5F5F5);
  static const Color COLOR_GAINS = Color(0xffE6E5FF);
  static const Color COLOR_GOOGLE = Color(0xffF0F7FF);
  static const Color COLOR_CART_BACKGROUND = Color(0xffF5F8FD);
  static const Color COLOR_QUARTZ = Color(0xffFBFAFD);
  static const Color COLOR_BACKGROUND = Color(0xffF7F6FB);
  static const Color COLOR_REGISTRATION_IMAGE_BACK = Color(0xffF9F6FF);
  static const Color COLOR_REGISTRATION_BACKGROUND = Color(0xffFBFAFF);
  static const Color COLOR_CARROT_ORANGE = Color(0xffF27E25);
  static const Color COLOR_DEEP_ORANGE = Color(0xffFF641A);
  static const Color COLOR_NEON_CARROT = Color(0xffFF913A);
  static const Color COLOR_ALIZARIN = Color(0xffF22C2C);
  static const Color COLOR_CARIBBEAN_GREEN = Color(0xff04D49E);
  static const Color COLOR_SHAMROCK = Color(0xff4AD4A3);
  static const Color COLOR_ICE_COLD = Color(0xffA6E2D5);
  static const Color COLOR_TWITTER = Color(0xff43ABFF);
  static const Color COLOR_BRIGHT_TURQUOISE = Color(0xff25DDF2);
  static const Color COLOR_MEDIUM_VIOLET_RED = Color(0xffE41397);
  static const Color COLOR_WILD_WATERMELON = Color(0xffFF6580);
  static const Color COLOR_DARK_ORCHID = Color(0xffA42AC3);

  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };

  static const MaterialColor PRIMARY_MATERIAL = MaterialColor(0xFF192D6B, colorMap);
}

List<Color> webColors = [appCat1, appCat2, appCat3];

// Light Theme Colors
const appColorPrimary = Color(0xFFB6985B);
const appColorAccent = Color(0xFF03DAC5);
const appTextColorPrimary = Color(0xFF212121);
const iconColorPrimary = Color(0xFFFFFFFF);
const appTextColorSecondary = Color(0xFF5A5C5E);
const iconColorSecondary = Color(0xFFA8ABAD);
const appLayout_background = Color(0xFFf8f8f8);
const appLight_purple = Color(0xFFdee1ff);
const appLight_orange = Color(0xFFffddd5);
const appLight_parrot_green = Color(0xFFb4ef93);
const appIconTintCherry = Color(0xFFffddd5);
const appIconTint_sky_blue = Color(0xFF73d8d4);
const appIconTint_mustard_yellow = Color(0xFFffc980);
const appIconTintDark_purple = Color(0xFF8998ff);
const appTxtTintDark_purple = Color(0xFF515BBE);
const appIconTintDarkCherry = Color(0xFFf2866c);
const appIconTintDark_sky_blue = Color(0xFF73d8d4);
const appDark_parrot_green = Color(0xFF5BC136);
const appDarkRed = Color(0xFFF06263);
const appLightRed = Color(0xFFF89B9D);
const appCat1 = Color(0xFF8998FE);
const appCat2 = Color(0xFFFF9781);
const appCat3 = Color(0xFF73D7D3);
const appCat4 = Color(0xFF87CEFA);
const appCat5 = appColorPrimary;
const appShadowColor = Color(0x95E9EBF0);
const appColorPrimaryLight = Color(0xFFF9FAFF);
const appSecondaryBackgroundColor = Color(0xFF131d25);
const appDividerColor = Color(0xFFDADADA);
const Color barbera = Color(0xFFD1870B);
const Color bellcommerce = Color(0xFF40BFFF);
const Color foodiy = Color(0xFFFF0303);
const Color furney = Color(0xFF5866A4);
const Color restoria = Color(0xFFFFEBA1);
const Color shuppy = Color(0xFFF6402E);
const Color treshop = Color(0xFFFC8080);
// Dark Theme Colors
const appBackgroundColorDark = Color(0xFF121212);
const cardBackgroundBlackDark = Color(0xFF1F1F1F);
const color_primary_black = Color(0xFF131d25);
const appColorPrimaryDarkLight = Color(0xFFF9FAFF);
const iconColorPrimaryDark = Color(0xFF212121);
const iconColorSecondaryDark = Color(0xFFA8ABAD);
const appShadowColorDark = Color(0x1A3E3942);
const Color background = Color(0xFFFFFFFF);
const Color card = Color(0xFFF8F8F8);
const Color fontTitle = Color(0xFF202020);
const Color fontSubtitle = Color(0xFF737373);
const Color fontDisable = Color(0xFF9B9B9B);
const Color disabledButton = Color(0xFFB9B9B9);
const Color divider = Color(0xFFDCDCDC);
const Color success = Color(0xFF388E3C);
const Color warning = Color(0xFFF57C00);
const Color error = Color(0xFFD32F2F);
const Color info = Color(0xFFB6985B);