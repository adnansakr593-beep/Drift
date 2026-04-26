import 'package:drift_app/helper/const.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController citySearchController;
  final void Function(String)? onChanged;
  final String? hintText;
  final bool loadingSearch;
  final void Function()? onPressed;
  final String? selectedCity;
  final EdgeInsetsGeometry? padding;
  final Color? hintColor;
  final Color? borderColor;
  final Color? iconColor;
  final double? borderWidth;

  const CustomSearchBar(
      {super.key,
      required this.citySearchController,
      this.onChanged,
      this.hintText,
      required this.loadingSearch,
      this.onPressed,
      this.selectedCity,
      this.padding,
      this.hintColor,
      this.borderColor,
      this.iconColor,
      this.borderWidth});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: colors.background.withOpacity(0.5),
                blurStyle: BlurStyle.inner),
          ],
          borderRadius: BorderRadius.circular(26),
          //shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),

          border: Border.all(
              color: borderColor ?? colors.onSurface.withOpacity(0.4),
              width: borderWidth ?? 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.search_rounded,
              color: iconColor ?? colors.onSurface.withOpacity(0.4),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: citySearchController,
                onChanged: onChanged,
                style: TextStyle(color: colors.onSurface, fontSize: 15),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: hintColor ?? colors.onSurface.withOpacity(0.35),
                      fontSize: 15,
                      fontFamily: fontFamily),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            if (loadingSearch)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.primary,
                  ),
                ),
              )
            else if (selectedCity != null)
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: iconColor ?? colors.onSurface.withOpacity(0.4),
                  size: 18,
                ),
                onPressed: onPressed,
              ),
          ],
        ),
      ),
    );
  }
}
