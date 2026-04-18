import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;
  final Color? borderColor;
  final Color? selectedColor;
  final double borderWidth;
  final double innerPadding;
  final bool? hasIcon;

  const CustomRadioButton({
    super.key,
    required this.isSelected,
    this.onTap,
    this.size = 20,
    this.borderColor,
    this.selectedColor,
    this.borderWidth = 0.8,
    this.innerPadding = 1.0,
    this.hasIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: borderColor ?? const Color(0xFFAFAFAF),
            width: borderWidth,
          ),
        ),
        child: isSelected
            ? Padding(
                padding: EdgeInsets.all(innerPadding),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selectedColor ?? Theme.of(context).colorScheme.primary,
                  ),
                  child: hasIcon == true
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: size / 2,
                        )
                      : null,
                ),
              )
            : null,
      ),
    );
  }
}
