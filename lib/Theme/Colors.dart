// ignore_for_file: file_names

//This file contains all the colors which is required for application UI Part .

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SAPColors{

  SAPColors._();
  static const Color globalBlackColor = Colors.black; // for globaly used black color in any UI Component
  static const Color globalWhiteColor = Colors.white; // for globaly used white color in any UI Component
  static const Color cancelButtonColor = Color.fromARGB(255, 233, 235, 238); // for cancel button 
 static const Color componentbackGroundColor = Color(0xffFFFFFF); // for any UI Component background color
  static const Color primaryButtonColor =  Color(0xff0070F2); // for Primary Button Color
  static const Color secondaryButtonColor =  Color.fromARGB(255, 237, 244, 255); // for Secondary Button Color
  static const Color snackbarBackgroundColor =  Color(0xff12171C); // for Snackbar Background
  static const Color primaryButtonTextColor = Colors.black; // for primary button text Color
  static const Color secondaryButtonTextColor = Colors.blueAccent; // for secondary button text Color
  static const Color focusedTextColor = Colors.blueAccent; // for focused Textfield  
  static const Color darkThemePrimaryColor = Color(0xff4DB1FF); // for Selected background
  static const Color bodybackGroundColor =  Color.fromARGB(255, 249, 253, 255); // background color other then UI Component
  static const Color cancelButtonTextColor = Color.fromARGB(255, 191, 77, 77);
  static const Color darkThemeBlackColor = Color(0xff14171A);
}


ThemeData sapLightThemeColors = ThemeData(
  extensions: [sAPLightTheme],
   pageTransitionsTheme:const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
);

ThemeData sapDarkThemeColors = ThemeData(
  extensions: [sAPDarkTheme],
   pageTransitionsTheme:const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
);

ThemeData sapIbThemeColors = ThemeData(
  extensions: [sAPIBTheme],
   pageTransitionsTheme:const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
);



class SAPTheme extends ThemeExtension<SAPTheme>{
  Color alertBoxBackgroundColor;
  Color alertBoxTitleColor;
  Color alertBoxsubTitleColor;
  Color bottomSheetBackgroundColor;
  Color primaryButtonBackgroundColor;
  Color primaryButtonIconColor;
  Color primaryButtonTextColor;
   Color secondaryButtonBackgroundColor;
  Color secondaryButtonIconColor;
  Color secondaryButtonTextColor;
   Color cancelButtonBackgroundColor;
  Color cancelButtonIconColor;
  Color cancelButtonTextColor;
  Color iconButtonColor;
  Color textButtonIconColor;
  Color textButtonColor;
  Color listTileBackgroundColor;
  Color listTileIconBackgroundColor;
  Color listTileIconColor;
  Color globalTextColor;
  Color dividerColor;
  Color loadingIndicatorColor;
  Color dataCardBackgroundColor;
  Color detailsCardShadowColor;
  Color detailsCardBackgroundColor;
  Color globalHeaderColor;
  Color dropdownMenuColor;
  Color slideractiveColor;
  Color sliderThumbColor;
  Color sliderDeactiveColor;
  Color snackbarBackgroundColor;
  Color snackbarTextColor;
  Color appBarBackgroundColor;

  SAPTheme({
    required this.appBarBackgroundColor,
    required this.snackbarTextColor,
    required this.snackbarBackgroundColor,
    required this.sliderDeactiveColor,
    required this.sliderThumbColor,
    required this.slideractiveColor,
    required this.dropdownMenuColor,
    required this.globalHeaderColor,
    required this.detailsCardBackgroundColor,
    required this.detailsCardShadowColor,
    required this.dataCardBackgroundColor,
    required this.loadingIndicatorColor,
    required this.dividerColor,
    required this.globalTextColor,
    required this.listTileIconBackgroundColor,
    required this.listTileIconColor,
    required this.listTileBackgroundColor,
    required this.textButtonIconColor,
    required this.textButtonColor,
    required this.iconButtonColor,
    required this.primaryButtonIconColor,
    required this.primaryButtonTextColor,
    required this.primaryButtonBackgroundColor,
    required this.cancelButtonIconColor,
    required this.cancelButtonTextColor,
    required this.cancelButtonBackgroundColor,
     required this.secondaryButtonIconColor,
    required this.secondaryButtonTextColor,
    required this.secondaryButtonBackgroundColor,
    required this.alertBoxBackgroundColor,
    required this.alertBoxTitleColor,
    required this.alertBoxsubTitleColor,
    required this.bottomSheetBackgroundColor});


  @override
  ThemeExtension<SAPTheme> copyWith() {
    return this;
  }
  @override
  ThemeExtension<SAPTheme> lerp(ThemeExtension<SAPTheme>? other, double t) {
    return this;
  }

}


SAPTheme sAPLightTheme = SAPTheme(
  appBarBackgroundColor: SAPColors.globalWhiteColor,
  snackbarTextColor: SAPColors.globalWhiteColor,
  snackbarBackgroundColor: SAPColors.snackbarBackgroundColor,
  sliderDeactiveColor:SAPColors.secondaryButtonColor ,
  slideractiveColor: SAPColors.primaryButtonColor,
  sliderThumbColor: SAPColors.secondaryButtonColor,
  dropdownMenuColor: SAPColors.globalWhiteColor,
  globalHeaderColor: SAPColors.globalBlackColor,
  detailsCardShadowColor: SAPColors.bodybackGroundColor,
  detailsCardBackgroundColor:SAPColors.globalWhiteColor ,
  dataCardBackgroundColor: SAPColors.globalWhiteColor,
  loadingIndicatorColor: SAPColors.primaryButtonColor,
  dividerColor: Colors.black12,
  alertBoxBackgroundColor: SAPColors.globalWhiteColor,
  alertBoxTitleColor: SAPColors.globalBlackColor,
  alertBoxsubTitleColor: SAPColors.globalBlackColor,
  bottomSheetBackgroundColor: SAPColors.globalWhiteColor,
  primaryButtonBackgroundColor: SAPColors.primaryButtonColor,
  primaryButtonIconColor: SAPColors.globalWhiteColor,
  primaryButtonTextColor: SAPColors.globalWhiteColor,
  iconButtonColor: SAPColors.primaryButtonColor,
  secondaryButtonBackgroundColor: SAPColors.secondaryButtonColor,
  secondaryButtonIconColor: SAPColors.primaryButtonColor,
  secondaryButtonTextColor: SAPColors.primaryButtonColor,
  cancelButtonBackgroundColor: SAPColors.cancelButtonColor,
  cancelButtonTextColor: SAPColors.cancelButtonTextColor,
  cancelButtonIconColor: SAPColors.cancelButtonTextColor,
  textButtonColor: SAPColors.primaryButtonColor,
  textButtonIconColor: SAPColors.primaryButtonColor,
  listTileBackgroundColor: SAPColors.globalWhiteColor,
  listTileIconBackgroundColor: SAPColors.secondaryButtonColor,
  listTileIconColor: SAPColors.primaryButtonColor,
  globalTextColor: SAPColors.globalBlackColor,

  );
SAPTheme sAPDarkTheme = SAPTheme(
  appBarBackgroundColor:SAPColors.darkThemeBlackColor ,
  snackbarTextColor: SAPColors.globalBlackColor,
  snackbarBackgroundColor: SAPColors.globalWhiteColor,
  sliderDeactiveColor:SAPColors.secondaryButtonColor ,
  slideractiveColor: SAPColors.darkThemePrimaryColor,
  sliderThumbColor: SAPColors.secondaryButtonColor,
  dropdownMenuColor: SAPColors.snackbarBackgroundColor,
  globalHeaderColor: SAPColors.globalWhiteColor,
  detailsCardBackgroundColor:SAPColors.darkThemeBlackColor ,
  detailsCardShadowColor: SAPColors.globalBlackColor,
  dataCardBackgroundColor: SAPColors.darkThemeBlackColor,
  loadingIndicatorColor: SAPColors.darkThemePrimaryColor,
  dividerColor:Colors.grey.shade800 ,
  alertBoxBackgroundColor: SAPColors.snackbarBackgroundColor,
  alertBoxTitleColor: SAPColors.globalWhiteColor,
  alertBoxsubTitleColor: SAPColors.globalWhiteColor,
  bottomSheetBackgroundColor: SAPColors.snackbarBackgroundColor,
  primaryButtonBackgroundColor: SAPColors.darkThemePrimaryColor,
  primaryButtonIconColor: SAPColors.globalWhiteColor,
  primaryButtonTextColor: SAPColors.globalWhiteColor,
  iconButtonColor: SAPColors.darkThemePrimaryColor,
  secondaryButtonBackgroundColor: SAPColors.secondaryButtonColor,
  secondaryButtonIconColor: SAPColors.darkThemePrimaryColor,
  secondaryButtonTextColor: SAPColors.darkThemePrimaryColor,
  cancelButtonBackgroundColor: SAPColors.cancelButtonColor,
  cancelButtonTextColor: SAPColors.cancelButtonTextColor,
  cancelButtonIconColor: SAPColors.cancelButtonTextColor,
  textButtonColor: SAPColors.darkThemePrimaryColor,
  textButtonIconColor: SAPColors.darkThemePrimaryColor,
  listTileBackgroundColor: SAPColors.darkThemeBlackColor,
  listTileIconBackgroundColor: SAPColors.secondaryButtonColor,
  listTileIconColor: SAPColors.darkThemePrimaryColor,
  globalTextColor: SAPColors.globalWhiteColor
  );
SAPTheme sAPIBTheme = SAPTheme(
  appBarBackgroundColor: SAPColors.globalWhiteColor,
  snackbarTextColor: SAPColors.globalWhiteColor,
  snackbarBackgroundColor: SAPColors.snackbarBackgroundColor,
  sliderDeactiveColor:Colors.green.shade100.withOpacity(0.3),
  slideractiveColor: Colors.green.shade600,
  sliderThumbColor: Colors.green.shade900,
  dropdownMenuColor: SAPColors.globalWhiteColor,
  globalHeaderColor: SAPColors.globalBlackColor,
   detailsCardShadowColor: SAPColors.bodybackGroundColor,
  detailsCardBackgroundColor:SAPColors.globalWhiteColor ,
  dataCardBackgroundColor: SAPColors.globalWhiteColor,
  loadingIndicatorColor: Colors.green.shade600,
  dividerColor: Colors.black12,
  alertBoxBackgroundColor: SAPColors.globalWhiteColor,
  alertBoxTitleColor: SAPColors.globalBlackColor,
  alertBoxsubTitleColor: SAPColors.globalBlackColor,
  bottomSheetBackgroundColor: SAPColors.globalWhiteColor,
  primaryButtonBackgroundColor: Colors.green.shade600,
  primaryButtonIconColor: SAPColors.globalWhiteColor,
  primaryButtonTextColor: SAPColors.globalWhiteColor,
  iconButtonColor: Colors.green.shade600,
  secondaryButtonBackgroundColor: Colors.green.shade100.withOpacity(0.3),
  secondaryButtonIconColor: Colors.green.shade600,
  secondaryButtonTextColor: Colors.green.shade600,
  cancelButtonBackgroundColor: SAPColors.cancelButtonColor,
  cancelButtonTextColor: SAPColors.cancelButtonTextColor,
  cancelButtonIconColor: SAPColors.cancelButtonTextColor,
  textButtonColor: Colors.green.shade600,
  textButtonIconColor: Colors.green.shade600,
  listTileBackgroundColor: SAPColors.globalWhiteColor,
  listTileIconBackgroundColor: Colors.green.shade100.withOpacity(0.3),
  listTileIconColor: Colors.green.shade600,
  globalTextColor: SAPColors.globalBlackColor
  );



