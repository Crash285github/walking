import 'package:flutter/material.dart';

Future<T?> showContextMenu<T>({
  required BuildContext context,
  required Offset offset,
  required List<PopupMenuEntry<T>> items,
}) async {
  return await showMenu<T>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(24),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.sizeOf(context).width,
      0,
    ),
    items: items,
  );
}
