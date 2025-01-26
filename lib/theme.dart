import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

Color primaryColor = const Color(0xFF4dd0e1);
Color secondaryColor = const Color(0xff38ABBE);
Color alertColor = const Color(0xffED6363);
Color priceColor = const Color(0xff00bcd4);
Color anotherColor = const Color(0xffC00000);


Color backgroundColor1 = const Color(0xffF1F0F2);
Color backgroundColor2 = const Color(0xffABD0BC);
Color backgroundColor3 = const Color(0xffF1F0F2);
Color backgroundColor4 = const Color(0xFF00bcd4);
Color backgroundColor5 = const Color(0xff2E2E2E);
Color backgroundColor6 = const Color(0xff1F1D2B);
Color backgroundColor7 = const Color(0xff3E3D3D);

Color primaryTextColor = const Color(0xff2B2B44);
Color secondaryTextColor = const Color(0xff242231);
Color subtitleColor = const Color(0xff252836);
Color transparentColor = Colors.transparent;
Color blackColor = const Color(0xff2B2B44);
Color headerColor1 = const Color(0xffABD0BC);
Color headerColor2 = const Color.fromARGB(255, 25, 26, 26);
Color shimmerColor = const Color(0xff999999);
Color succesColor = const Color(0xff66bb6a);

TextStyle headerTextStyle1 = GoogleFonts.poppins(color: headerColor1);

TextStyle headerTextStyle2 = GoogleFonts.poppins(color: headerColor2);

TextStyle primaryTextStyle = GoogleFonts.poppins(color: primaryTextColor);

TextStyle secondaryTextStyle = GoogleFonts.poppins(color: secondaryTextColor);

TextStyle subtitleTextStyle = GoogleFonts.poppins(color: subtitleColor);

TextStyle whiteTextStyle = GoogleFonts.poppins(color: backgroundColor1);

TextStyle priceTextStyle = GoogleFonts.poppins(color: priceColor);

TextStyle purpleTextStyle = GoogleFonts.poppins(color: primaryColor);

TextStyle blackTextStyle = GoogleFonts.poppins(color: blackColor);

TextStyle alertTextStyle = GoogleFonts.poppins(color: alertColor);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

void successNotif(text, context) {
  AnimatedSnackBar.material(text, type: AnimatedSnackBarType.success)
      .show(context);
}

void errorNotif(text, context) {
  AnimatedSnackBar.material(text, type: AnimatedSnackBarType.error)
      .show(context);
}

void infoNotif(text, context) {
  AnimatedSnackBar.material(text, type: AnimatedSnackBarType.info)
      .show(context);
}

void warningNotif(text, context) {
  AnimatedSnackBar.material(text, type: AnimatedSnackBarType.warning)
      .show(context);
}