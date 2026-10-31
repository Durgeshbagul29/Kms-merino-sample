// https://flutkit.coderthemes.com/shots-gallery.html

import 'package:flutter/material.dart';

const defaultValue = 56.0;

class CustomLoader extends StatelessWidget {
  static OverlayEntry? _currentLoader;
  const CustomLoader._(this._progressIndicator, this._loaderText);
  final Widget _progressIndicator;
  final Widget _loaderText;

  static OverlayState? _overlayState;

  /// If you need to show an normal overlayloader,
  /// just call Loader.show() with a build context. BuildContext is a required param.

  static void show(BuildContext context,
      {

        /// Define your custom progress indicator if you want [optional]
        required Widget progressIndicator,

        required Widget loaderText,

        /// Define Theme [optional]
        ThemeData? themeData,

        /// Define Overlay color [optional]
        Color overlayColor = const Color(0x99ffffff),

        /// overlayTop mean overlay start from Top margin. If you have custom appbar and you want to show loader without custom appbar then will be custom appbar height here and also you have to make sure [isAppbarOverlay = false].
        double? overlayFromTop,

        /// overlayFromBottom mean overlay end to Bottom margin.If you have custom BottomAppBar and you want to show loader without custom BottomAppBar then will be custom BottomAppBar height here and also you have to make sure [isBottomBarOverlay = false].
        double? overlayFromBottom,

        /// isAppbarOverlay default true. If you need to appbar outside from overlay loader then make it false.
        bool isAppbarOverlay = true,

        /// isBottomBarOverlay default true. If you need to Bottombar outside from overlay loader then make it false.
        bool isBottomBarOverlay = true,

        /// isSafeAreaOverlay default true. If you don't want to overlay  your safe area like statusbar and bottomnavbar then make it false.
        bool isSafeAreaOverlay = true}) {
    var safeBottomPadding = MediaQuery.of(context).padding.bottom;
    var defaultPaddingTop = 0.0;
    var defaultPaddingBottom = 0.0;
    if (!isAppbarOverlay) {
      isSafeAreaOverlay = false;
    }
    if (!isSafeAreaOverlay) {
      defaultPaddingTop = defaultValue;
      defaultPaddingBottom = defaultValue + safeBottomPadding;
    } else {
      defaultPaddingTop = defaultValue;
      defaultPaddingBottom = defaultValue;
    }

    _overlayState = Overlay.of(context);
    if (_currentLoader == null) {
      ///Create current Loader Entry
      _currentLoader = OverlayEntry(builder: (context) {
        return Stack(
          children: <Widget>[
            _overlayWidget(
                isSafeAreaOverlay,
                overlayColor,
                isAppbarOverlay ? 0.0 : overlayFromTop ?? defaultPaddingTop,
                isBottomBarOverlay
                    ? 0.0
                    : overlayFromBottom ?? defaultPaddingBottom),
            Center(child: CustomLoader._(
              progressIndicator,
              loaderText,
            )),
          ],
        );
      });

      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_currentLoader != null) {
            _overlayState?.insert(_currentLoader!);
          }
        });
      } catch (e) {debugPrint('$e');}
    }
  }

  static Widget _overlayWidget(bool isSafeArea, Color overlayColor,
      double overlayFromTop, double overlayFromBottom) {
    return isSafeArea
        ? Container(
      color: overlayColor,
      margin:
      EdgeInsets.only(top: overlayFromTop, bottom: overlayFromBottom),
    )
        : SafeArea(
        child: Container(
          color: overlayColor,
          margin:
          EdgeInsets.only(top: overlayFromTop, bottom: overlayFromBottom),
        ));
  }

  /// You have to call hide() method in the dispose method to clear
  ///  the overlay or hide your loader when your view is disposed otherwise throws an exception.
  /// And also you have to call hide() method when you need to hide your overlay loader. For exmaple, After finishing your api call you need to hide your loader. then just call Loader.hide()
  static void hide() {
    if (_currentLoader != null) {
      try {
        _currentLoader?.remove();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _currentLoader = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Theme(
          data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue)),
          child: Column(
              crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                _progressIndicator,
                _loaderText,
                // _progressIndicator ?? CircularProgressIndicator(backgroundColor:Colors.blue.shade800),
                // Text("\n"+_loaderText,style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black,decoration: TextDecoration.none),textAlign: TextAlign.center,) ?? Text(" "),
              ]
          ),

        ));
  }
}
