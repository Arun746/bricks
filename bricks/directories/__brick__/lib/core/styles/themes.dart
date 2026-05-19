import 'package:flutter/material.dart';

abstract class _BaseTheme {
  AppBarTheme get appBarTheme;
  TabBarThemeData get tabBarTheme;
  CardThemeData get cardTheme;
  TextTheme get textTheme;
  IconThemeData get iconThemeData;
  InputDecorationTheme get inputDecorationTheme;
  ElevatedButtonThemeData get elevatedButtonThemeData;
  OutlinedButtonThemeData get outlinedButtonThemeData;
  IconButtonThemeData get iconButtonThemeData;
  SnackBarThemeData get snackBarThemeData;
  TextButtonThemeData get textButtonThemeData;
  CheckboxThemeData get checkBoxThemeData;
  late Color backgroundColor;
  late Color surfaceColor;
  late Color primaryColor;
  late Color secondaryColor;
  late Color errorColor;
  late Color onErrorColor;
  late Color onSecondaryColor;
  late Color onBackgroundColor;
  late Color onSurfaceColor;
  late Color onPrimaryColor;
}

class CustomTheme {
  static ThemeData get light => _LightTheme().theme;
  static ThemeData get dark => _LightTheme().theme;

  static ButtonStyle get elevatedButtonOutlined => ButtonStyle(
        textStyle: const WidgetStatePropertyAll(TextStyle(
          color: Color(0x99000000),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
        )),
        maximumSize: const WidgetStatePropertyAll(Size(340, 52)),
        minimumSize: const WidgetStatePropertyAll(Size(120, 46)),
        foregroundColor: const WidgetStatePropertyAll(Color(0x99000000)),
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        iconColor: const WidgetStatePropertyAll(Color(0x99000000)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side:
                BorderSide(color: Color(0x99000000).withOpacity(0.5), width: 1),
          ),
        ),
      );
}

class _LightTheme implements _BaseTheme {
  @override
  Color backgroundColor = Colors.white;

  @override
  Color errorColor = Colors.red;
  // Color errorColor = const Color(0xffFF9D9D);

  @override
  Color onBackgroundColor = const Color(0xFF474646);

  @override
  Color onErrorColor = Colors.white;

  @override
  Color onPrimaryColor = Colors.white;

  @override
  Color onSecondaryColor = Colors.white;

  @override
  Color onSurfaceColor = const Color(
      0xFF474646); // Changed to secondary color for better contrast on white surface

  @override
  Color primaryColor = const Color(0xFF403157);

  @override
  Color secondaryColor = const Color(0xFF000000);

  @override
  Color surfaceColor = Colors.white; // Changed to white to match background
  ThemeData get theme => ThemeData(
        fontFamily: 'AlbertSans',
        appBarTheme: appBarTheme,
        shadowColor: const Color(0xff000000).withOpacity(.2),
        textTheme: textTheme,
        iconButtonTheme: iconButtonThemeData,
        iconTheme: iconThemeData,
        elevatedButtonTheme: elevatedButtonThemeData,
        outlinedButtonTheme: outlinedButtonThemeData,
        inputDecorationTheme: inputDecorationTheme,
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        cardColor: surfaceColor,
        checkboxTheme: checkBoxThemeData,
        tabBarTheme: tabBarTheme,
        textButtonTheme: textButtonThemeData,
        cardTheme: cardTheme,
        snackBarTheme: snackBarThemeData,
        colorScheme: ColorScheme(
            background: backgroundColor,
            onBackground: onBackgroundColor,
            surface: surfaceColor,
            onSurface: onSurfaceColor,
            error: errorColor,
            onError: onErrorColor,
            brightness:
                Brightness.light, // Changed to light since background is white
            primary: primaryColor,
            secondary: secondaryColor,
            onPrimary: onPrimaryColor,
            onSecondary: onSecondaryColor),
      );

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(
      color: Color(0xFF000000),
      width: 1,
    ),
  );

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        errorMaxLines: 3,
        filled: true,
        hintStyle: const TextStyle(
            fontSize: 16,
            color: Color(0xFF484848),
            fontWeight: FontWeight.w300),
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 22,
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        isDense: false,
      );

  @override
  IconThemeData get iconThemeData => IconThemeData(color: secondaryColor);

  @override
  ElevatedButtonThemeData get elevatedButtonThemeData =>
      ElevatedButtonThemeData(
          style: ButtonStyle(
        textStyle: const WidgetStatePropertyAll(TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
        )),
        maximumSize: const WidgetStatePropertyAll(Size(340, 52)),
        minimumSize: const WidgetStatePropertyAll(Size(120, 52)),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
        backgroundColor: WidgetStatePropertyAll(const Color(0xff4F5583)),
        iconColor: const WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.transparent, width: 0.5))),
      ));

  @override
  OutlinedButtonThemeData get outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: const WidgetStatePropertyAll(TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          )),
          maximumSize: const WidgetStatePropertyAll(Size(340, 52)),
          minimumSize: const WidgetStatePropertyAll(Size(120, 52)),
          foregroundColor: const WidgetStatePropertyAll(Color(0xFF000000)),
          iconColor: const WidgetStatePropertyAll(Color(0xFF000000)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(
              color: Color(0xFF000000),
              width: 1,
            ),
          ),
        ),
      );

  @override
  IconButtonThemeData get iconButtonThemeData => IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(
            Color(0xFF000000),
          ),
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          backgroundBuilder: (_, __, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Color(0xFF000000),
                  width: 1,
                ),
              ),
              child: child,
            );
          },
        ),
      );

  @override
  TextTheme get textTheme => TextTheme(
        headlineLarge: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 28, color: secondaryColor),
        headlineMedium: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: secondaryColor),
        headlineSmall: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 18, color: secondaryColor),
        bodyLarge: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16, color: secondaryColor),
        bodyMedium: TextStyle(
            fontWeight: FontWeight.w500, fontSize: 12, color: secondaryColor),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: secondaryColor.withOpacity(0.8),
        ),
      ); // Using secondary color with slight opacity for small text

  @override
  CardThemeData get cardTheme =>
      CardThemeData(shadowColor: const Color(0xff000000).withOpacity(.2));

  @override
  AppBarTheme get appBarTheme => AppBarTheme(
      backgroundColor: Colors.white, // Added explicit background color
      foregroundColor: secondaryColor, // Changed to secondary color
      iconTheme:
          IconThemeData(color: secondaryColor), // Changed to secondary color
      centerTitle: true,
      titleTextStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600, fontSize: 18, color: secondaryColor));

  @override
  SnackBarThemeData get snackBarThemeData => SnackBarThemeData(
      backgroundColor: primaryColor, behavior: SnackBarBehavior.floating);

  @override
  TextButtonThemeData get textButtonThemeData => TextButtonThemeData(
      style: ButtonStyle(
          backgroundColor:
              WidgetStatePropertyAll(Colors.white.withOpacity(0.2)),
          foregroundColor: WidgetStatePropertyAll(onSecondaryColor)));

  @override
  TabBarThemeData get tabBarTheme =>
      const TabBarThemeData(dividerColor: Colors.transparent);

  @override
  CheckboxThemeData get checkBoxThemeData => CheckboxThemeData(
        side: BorderSide(color: const Color(0xFFAFAFAF), width: 1.5),
        shape: const CircleBorder(),
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
}
