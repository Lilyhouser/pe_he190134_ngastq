import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobilePortrait;
  final Widget mobileLandscape;
  final Widget tablet;

  const ResponsiveLayout({
    super.key,
    required this.mobilePortrait,
    required this.mobileLandscape,
    required this.tablet,
  });

  static bool isMobilePortrait(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isMobileLandscape(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return width >= 600 && width < 900 || (height < 500 && width >= 500);
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        if (width >= 900) {
          return tablet;
        } else if (width >= 600 || (height < 500 && width >= 500)) {
          return mobileLandscape;
        } else {
          return mobilePortrait;
        }
      },
    );
  }
}
