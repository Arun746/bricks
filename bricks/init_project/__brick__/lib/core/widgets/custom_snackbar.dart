import 'package:flutter/material.dart';
import 'package:wrench_and_bolts/core/enums/enums.dart';
import 'package:wrench_and_bolts/core/styles/assets.dart';
import 'package:wrench_and_bolts/core/utils/functions.dart';

SnackBar customSnackbar(
    {required String message,
    Duration? duration,
    SnackBarAction? action,
    required BuildContext context,
    double bottomMargin = 0.0,
    SnackbarType type = SnackbarType.info}) {
  const errorColor = Color(0xffFF6174);
  const infoColor = Color(0xff2196F3);
  const successColor = Color(0xff1DB984);
  String iconPath = AssetsPath.snackbarInfo;
  if (type == SnackbarType.error) {
    iconPath = AssetsPath.snackbarError;
  } else if (type == SnackbarType.success) {
    iconPath = AssetsPath.snackbarSuccess;
  }
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(
        vertical: (bottomMargin) + (isPhoneScreen(context) ? 8 : 16),
        horizontal: isPhoneScreen(context)
            ? 16
            : isTabletScreen(context)
                ? 50
                : 100),
    shape: const StadiumBorder(),
    elevation: 5,
    showCloseIcon: action != null,
    action: action,
    duration: duration ?? const Duration(seconds: 3),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          iconPath,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.info,
              size: 28,
              color: type == SnackbarType.error
                  ? errorColor
                  : type == SnackbarType.success
                      ? successColor
                      : infoColor,
            );
          },
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: type == SnackbarType.error
                    ? errorColor
                    : type == SnackbarType.success
                        ? successColor
                        : infoColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // const Spacer()
      ],
    ),
  );
}
