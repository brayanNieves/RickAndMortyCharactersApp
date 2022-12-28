import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget(
      {Key? key,
      this.padding,
      this.onChanged,
      this.cancelTap,
      this.onSearchTap,
      required this.controller,
      this.autoFocus = false,
      this.autocorrect = true,
      this.suffixIcon,
      this.enableSuggestions = true,
      this.focusNode})
      : super(key: key);

  final String hint = 'Filter by name, status and species';
  final EdgeInsetsGeometry? padding;
  final double borderRadius = 12.0;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? cancelTap;
  final bool autoFocus;
  final bool autocorrect;
  final bool enableSuggestions;
  final GestureTapCallback? onSearchTap;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(12.0))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: autoFocus,
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      autocorrect: autocorrect,
                      enableSuggestions: enableSuggestions,
                      decoration: InputDecoration(
                        hintText: hint,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (suffixIcon != null) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: suffixIcon ?? const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
