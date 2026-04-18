import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_thumbnail_plus/video_thumbnail_plus.dart';
import 'package:wrench_and_bolts/core/enums/enums.dart';
import 'package:wrench_and_bolts/core/exceptions/api_exception.dart';
import 'package:wrench_and_bolts/core/exceptions/general_exception.dart';
import 'package:wrench_and_bolts/core/exceptions/network_exception.dart';
import 'package:wrench_and_bolts/core/services/http/http_service_impl.dart';
import 'package:wrench_and_bolts/core/services/routing/routing.dart';
import 'package:wrench_and_bolts/core/services/storage/database/database.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/auth_box/auth_box.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/user_box/user_box.dart';
import 'package:wrench_and_bolts/core/utils/constants.dart';
import 'package:wrench_and_bolts/core/widgets/scaffold_body/scaffold_body_provider.dart';
import 'package:wrench_and_bolts/features/authentication/repositories/authentication_repository_impl.dart';
import 'package:wrench_and_bolts/features/notification/repositories/notification_repository_impl.dart';
import 'package:wrench_and_bolts/core/services/storage/hive/app_box/app_box.dart';

import '../exceptions/exception_message.dart';
import '../widgets/custom_snackbar.dart';

// Global variable to track current sidebar snackbar overlay entry
OverlayEntry? _currentSidebarSnackbar;

void showSnackbar({
  required String message,
  required BuildContext context,
  Duration? duration,
  SnackBarAction? action,
  bool preserveSnackbarQueue = false,
  double bottomMargin = 0,
  required SnackbarType type,
  AuthenticationContext? authContext,
}) {
  if (!context.mounted) return;

  if (authContext == AuthenticationContext.webSidebar) {
    // Remove current sidebar snackbar if preserveSnackbarQueue is false
    if (preserveSnackbarQueue == false) {
      _removeCurrentSidebarSnackbar();
    }
    _showSidebarSnackbar(
      context: context,
      message: message,
      type: type,
      duration: duration ?? const Duration(seconds: 1),
    );
  } else {
    if (preserveSnackbarQueue == false) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }
    ScaffoldMessenger.of(context).showSnackBar(customSnackbar(
        bottomMargin: bottomMargin,
        message: message,
        context: context,
        type: type,
        duration: duration,
        action: action));
  }
}

void showErrorSnackbar(
  error,
  BuildContext context, {
  Duration? duration,
  double bottomMargin = 0,
  bool preserveSnackbarQueue = false,
  AuthenticationContext? authContext,
}) {
  ///do not show snackbar in case of logging/logged out until relogin
  // if (LoginSession.instance.isChecking) {
  //   return;
  // }
  late String message;
  late SnackbarType snackbarType;
  if (error is ApiException) {
    message = error.message;
    snackbarType =
        error.statusCode == 429 ? SnackbarType.info : SnackbarType.error;
  } else if (error is GeneralException) {
    message = error.message;
    snackbarType = SnackbarType.error;
  } else if (error is NetworkException) {
    message = error.toString();
    snackbarType = SnackbarType.error;
  } else {
    message = ExceptionMessage.unknown;
    snackbarType = SnackbarType.error;
  }

  Future(
    () => showSnackbar(
      preserveSnackbarQueue: preserveSnackbarQueue,
      message: message,
      bottomMargin: bottomMargin,
      context: context,
      type: snackbarType,
      duration: duration,
      authContext: authContext,
    ),
  );
}

void _removeCurrentSidebarSnackbar() {
  if (_currentSidebarSnackbar != null) {
    _currentSidebarSnackbar!.remove();
    _currentSidebarSnackbar = null;
  }
}

void _showSidebarSnackbar({
  required BuildContext context,
  required String message,
  required SnackbarType type,
  required Duration duration,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  // Get the colors and styling from customSnackbar logic
  const errorColor = Color(0xffFF6174);
  const infoColor = Color(0xff2196F3);
  const successColor = Color(0xff1DB984);

  String iconPath = 'assets/icons/snackbar/snackbar_info.png';
  if (type == SnackbarType.error) {
    iconPath = 'assets/icons/snackbar/snackbar_error.png';
  } else if (type == SnackbarType.success) {
    iconPath = 'assets/icons/snackbar/snackbar_success.png';
  }

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 20,
      right: 20,
      width: 460,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: isPhoneScreen(context) ? 8 : 16,
            horizontal: isPhoneScreen(context)
                ? 16
                : isTabletScreen(context)
                    ? 50
                    : 100,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    type == SnackbarType.error
                        ? Icons.error
                        : type == SnackbarType.success
                            ? Icons.check_circle
                            : Icons.info,
                    size: 28,
                    color: type == SnackbarType.error
                        ? errorColor
                        : type == SnackbarType.success
                            ? successColor
                            : infoColor,
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: type == SnackbarType.error
                                ? errorColor
                                : type == SnackbarType.success
                                    ? successColor
                                    : infoColor,
                          ) ??
                      TextStyle(
                        color: type == SnackbarType.error
                            ? errorColor
                            : type == SnackbarType.success
                                ? successColor
                                : infoColor,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Store the current overlay entry for potential removal
  _currentSidebarSnackbar = overlayEntry;
  overlay.insert(overlayEntry);

  // Auto-remove after duration
  Future.delayed(duration, () {
    if (_currentSidebarSnackbar == overlayEntry) {
      overlayEntry.remove();
      _currentSidebarSnackbar = null;
    }
  });
}

bool isSmallScreen(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width <= Constants.smallPhoneDisplay;
}

bool isPhoneScreen(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width <= Constants.smallDisplay;
}

bool isTabletScreen(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width > Constants.smallDisplay && width <= Constants.mediumDisplay;
}

bool isDesktopScreen(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width > Constants.mediumDisplay;
}

Future<String> getDeviceId() async {
  if (Platform.isAndroid) {
    const androidIdPlugin = AndroidId();

    ///this is a unique per user per device and might change if factory reset
    ///documentation: https://developer.android.com/reference/android/provider/Settings.Secure#ANDROID_ID
    ///stackoverflow discussion: https://stackoverflow.com/a/43393373
    final String? androidId = await androidIdPlugin.getId();

    if (androidId == null) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.id;
    } else {
      return androidId;
    }
  } else {
    final iosInfo = await DeviceInfoPlugin().iosInfo;

    ///If the user uninstalls all your apps, and then reinstalls, the identifierForVendor will reset.
    ///The vendor means the App provider.
    return iosInfo.identifierForVendor ?? iosInfo.name;
  }
}

String extractExtension(String fileName) {
  final parts = fileName.split('.');
  if (parts.length > 1) {
    return parts.last;
  }
  return '';
}

Future<double?> getFileSizeInMB(String? filePath) async {
  if (filePath == null) return null;
  try {
    final fileBytes = (await File(filePath).readAsBytes()).length;
    final sizeMB = fileBytes / pow(1024, 2);
    return sizeMB;
  } catch (_) {
    return null;
  }
}

/// Formats a placemark into a readable address string
/// Format: "Place Name, Street Name, City, Country"
/// Example: "RoseBowl Stadium, abc Street, LA, USA"
String getFormattedAddress(placemark) {
  // Extract address components
  final placeName = placemark.name ?? '';
  final streetName = placemark.thoroughfare ?? '';
  final administrativeArea = placemark.administrativeArea ?? '';
  final country = placemark.country ?? '';

  // Build formatted address parts
  List<String> addressParts = [];

  // Add place/business name (highest priority)
  if (placeName.isNotEmpty) {
    addressParts.add(placeName);
  }

  // Add street name
  if (streetName.isNotEmpty && (streetName != placeName)) {
    addressParts.add(streetName);
  }

  // Add city
  if (administrativeArea.isNotEmpty) {
    addressParts.add(administrativeArea);
  }

  // Add country
  if (country.isNotEmpty) {
    addressParts.add(country);
  }

  return addressParts.join(', ');
}

bool isLoggedIn() {
  try {
    return AuthBox.getAccessToken() != null;
  } catch (_) {
    return false;
  }
}

Future<void> logout({required BuildContext context}) async {
  try {
    _enableLoading();

    // Unregister FCM token before logout
    final fcmToken = AppBox.getFCMToken();
    if (fcmToken != null) {
      try {
        await NotificationRepositoryImpl(HttpServiceImpl())
            .unregisterToken(fcmToken: fcmToken);
      } catch (_) {}
    }

    await AuthenticationRepositoryImpl(HttpServiceImpl()).logOut();
    showSnackbar(
      message: 'Logged out Successfully !',
      context: context,
      type: SnackbarType.success,
    );
  } catch (error, stackTrace) {
    Zone.current.handleUncaughtError(error, stackTrace);
    showErrorSnackbar(error, context);
  } finally {
    await UserBox.clear();
    await AuthBox.clear();
    await AppBox.clear();
    final container = ProviderScope.containerOf(context);
    final database = container.read(databaseProvider);
    await database.clearAllTables();
    context.go(RoutePath.initial);
    _disableLoading();
  }
}

void _enableLoading() {
  final context = navigatorKey.currentContext;
  if (context != null) {
    final container = ProviderContainer();
    container.read(scaffoldBodyProvider.notifier).enableLoading();
  }
}

void _disableLoading() {
  final context = navigatorKey.currentContext;
  if (context != null) {
    final container = ProviderContainer();
    container.read(scaffoldBodyProvider.notifier).disableLoading();
  }
}

extension UnicodeFlagExtension on String {
  String get unicodeToEmoji {
    final parts = toUpperCase().replaceAll('U+', '').split('-');

    if (parts.length != 2) return '🌍';

    try {
      final first = int.parse(parts[0], radix: 16);
      final second = int.parse(parts[1], radix: 16);

      return String.fromCharCode(first) + String.fromCharCode(second);
    } catch (e) {
      return '🌍';
    }
  }
}

DioMediaType? getContentTypeFromFileName(String fileName) {
  final extension = extractExtension(fileName).toLowerCase();
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return DioMediaType('image', 'jpeg');
    case 'png':
      return DioMediaType('image', 'png');
    case 'gif':
      return DioMediaType('image', 'gif');
    case 'webp':
      return DioMediaType('image', 'webp');
    case 'heic':
      return DioMediaType('image', 'heic');

    case 'mp4':
      return DioMediaType('video', 'mp4');
    case 'webm':
      return DioMediaType('video', 'webm');
    case 'mkv':
      return DioMediaType('video', 'x-matroska');
    case 'avi':
      return DioMediaType('video', 'x-msvideo');
    case 'mov':
      return DioMediaType('video', 'quicktime');
    case 'flv':
      return DioMediaType('video', 'x-flv');

    case 'mp3':
      return DioMediaType('audio', 'mpeg');
    case 'wav':
      return DioMediaType('audio', 'wav');
    case 'ogg':
      return DioMediaType('audio', 'ogg');
    case 'aac':
      return DioMediaType('audio', 'aac');
    case 'flac':
      return DioMediaType('audio', 'flac');
    case 'm4a':
      return DioMediaType('audio', 'mp4');
    // case 'webm':
    //   return DioMediaType('audio', 'webm');
    default:
      return null;
  }
}

Future<Uint8List?> generateVideoThumbnail(String videoPath,
    {Uint8List? videoBytes}) async {
  try {
    if (videoPath.isEmpty) {
      return null;
    }

    final file = File(videoPath);
    if (!await file.exists()) {
      return null;
    }

    final thumbnail = await VideoThumbnailPlus.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      maxHeight: 200,
      quality: 50,
      timeMs: 1000,
    );

    return thumbnail;
  } catch (e, stackTrace) {
    Zone.current.handleUncaughtError(e, stackTrace);
    return null;
  }
}
