import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

/// Go back to previous screen.
void finish(BuildContext context, [Object? result]) {
  if (Navigator.canPop(context)) Navigator.pop(context, result);
}

/// Go to new screen with provided screen tag.
///
/// ```dart
/// launchNewScreen(context, '/HomePage');
/// ```
Future<T?> launchNewScreen<T>(BuildContext context, String tag) async =>
    Navigator.of(context).pushNamed(tag);

/// Removes all previous screens from the back stack and redirect to new screen with provided screen tag
///
/// ```dart
/// launchNewScreenWithNewTask(context, '/HomePage');
/// ```
Future<T?> launchNewScreenWithNewTask<T>(
        BuildContext context, String tag) async =>
    Navigator.of(context).pushNamedAndRemoveUntil(tag, (r) => false);

/// Change status bar Color and Brightness
Future<void> setStatusBarColor(
  Color statusBarColor, {
  Color? systemNavigationBarColor,
  Brightness? statusBarBrightness,
  Brightness? statusBarIconBrightness,
  int delayInMilliSeconds = 200,
}) async {
  await Future.delayed(Duration(milliseconds: delayInMilliSeconds));

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      systemNavigationBarColor: systemNavigationBarColor,
      statusBarBrightness: statusBarBrightness,
      statusBarIconBrightness: statusBarIconBrightness ??
          (statusBarColor.isDark() ? Brightness.light : Brightness.dark),
    ),
  );
}

/// This function will show status bar
Future<void> showStatusBar() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
}

/// This function will hide status bar
Future<void> hideStatusBar() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

/// Set orientation to portrait
void setOrientationPortrait() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

/// Set orientation to landscape
void setOrientationLandscape() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

/// Returns current PlatformName
String platformName() {
  if (isLinux) return 'Linux';
  if (isWeb) return 'Web';
  if (isMacOS) return 'macOS';
  if (isWindows) return 'Windows';
  if (isAndroid) return 'Android';
  if (isIOS) return 'iOS';
  return '';
}

/// Custom scroll behaviour
Widget Function(BuildContext, Widget?)? scrollBehaviour() {
  return (context, child) {
    return ScrollConfiguration(behavior: SBehavior(), child: child!);
  };
}

/// Custom scroll behaviour widget
class SBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

/// Invoke Native method and get result
Future<T?> invokeNativeMethod<T>(String channel, String method,
    [dynamic arguments]) async {
  var platform = MethodChannel(channel);
  return await platform.invokeMethod<T>(method, arguments);
}

/// Prints only if in debug or profile mode
void log(Object? value) {
  if (!kReleaseMode || forceEnableDebug) print(value);
}

/// Return true if Android OS version is above 12
Future<bool> isAndroid12Above() async {
  if (isAndroid) {
    return (await invokeNativeMethod('nb_utils', 'isAndroid12Above') as bool);
  } else {
    return false;
  }
}

/// Returns material you colors from Android
Future<dynamic> getMaterialYouColors() async {
  if (isAndroid) {
    return await invokeNativeMethod('nb_utils', 'materialYouColors');
  } else {
    return {};
  }
}

/// Returns primary color for material you theme
Future<Color> getMaterialYouPrimaryColor() async {
  Map colors = await getMaterialYouColors();

  return colors['system_accent1_400'].toString().toColor();
}

/// Returns material you ThemeData
Future<ThemeData> getMaterialYouTheme() async {
  Map colors = await getMaterialYouColors();

  Color accent50 = colors['system_accent1_50'].toString().toColor();
  Color accent100 = colors['system_accent1_100'].toString().toColor();
  Color accent200 = colors['system_accent1_200'].toString().toColor();
  Color accent300 = colors['system_accent1_300'].toString().toColor();
  Color accent400 = colors['system_accent1_400'].toString().toColor();
  Color accent500 = colors['system_accent1_500'].toString().toColor();
  Color accent600 = colors['system_accent1_600'].toString().toColor();

  return ThemeData(
    //primarySwatch: createMaterialColor(accent300),
    primaryColor: accent400,
    //scaffoldBackgroundColor: accent50,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: createMaterialColor(accent300),
      cardColor: accent50,
      //backgroundColor: accent50,
    ),
  );
}
