import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController citySearchController;
  final void Function(String)? onChanged;
  final String? hintText;
  final bool loadingSearch;
  final void Function()? onPressed;
  final String? selectedCity;

  const CustomSearchBar(
      {super.key,
      required this.citySearchController,
      this.onChanged,
      this.hintText,
      required this.loadingSearch,
      this.onPressed,
      this.selectedCity});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.onSurface.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.search_rounded,
              color: colors.onSurface.withOpacity(0.4),
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
                    color: colors.onSurface.withOpacity(0.35),
                    fontSize: 15,
                  ),
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
                  color: colors.onSurface.withOpacity(0.4),
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
