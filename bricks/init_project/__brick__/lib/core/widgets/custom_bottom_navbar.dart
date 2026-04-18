import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench_and_bolts/core/services/routing/routing.dart';
import 'package:wrench_and_bolts/core/styles/assets.dart';
import 'package:wrench_and_bolts/core/utils/extensions/go_router_extension.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Color(
            0xFFBDBDBD,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                final router = GoRouter.of(context);
                final currentLocation = router.location;
                if (currentLocation != RoutePath.home) {
                  context.go(RoutePath.home);
                }
              },
              child: SvgPicture.asset(
                AssetsPath.homeIcon,
                height: 26,
              ),
            ),
            GestureDetector(
              onTap: () {
                final router = GoRouter.of(context);
                final currentLocation = router.location;
                if (currentLocation != RoutePath.offer) {
                  context.push(RoutePath.offer);
                }
              },
              child: SvgPicture.asset(
                AssetsPath.offerIcon,
                height: 26,
              ),
            ),
            GestureDetector(
              onTap: () {
                final router = GoRouter.of(context);
                final currentLocation = router.location;
                if (currentLocation != RoutePath.profile) {
                  context.push(RoutePath.profile);
                }
              },
              child: SvgPicture.asset(
                AssetsPath.profileIcon,
                height: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
