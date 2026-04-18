import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wrench_and_bolts/core/styles/assets.dart';

class AppHeader extends StatelessWidget {
  final double? iconHeight;
  final TextStyle? titleStyle;
  const AppHeader({super.key, this.iconHeight, this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AssetsPath.appIcon,
          color: Theme.of(context).primaryColor,
          height: iconHeight ?? 90,
        ),
        Text(
          'Wrench \n& Bolts',
          style: titleStyle ?? Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
