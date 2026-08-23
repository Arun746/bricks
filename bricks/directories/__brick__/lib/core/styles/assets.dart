class AssetsPath {
  static const _assets = 'assets';
  //package is using assets/ by default so that ignoring assets in path

  static const _icons = '$_assets/icons';

  static const _snackbar = '$_icons/snackbar';

  static String get snackbarInfo => '$_snackbar/snackbar_info.png';

  static String get snackbarError => '$_snackbar/snackbar_error.png';

  static String get snackbarSuccess => '$_snackbar/snackbar_success.png';
}
