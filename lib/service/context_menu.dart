import 'package:flutter/material.dart';

Future<T?> showContextMenu<T>({
  required BuildContext context,
  required Offset offset,
  required List<PopupMenuEntry<T>> items,
}) async {
  return await showMenu<T>(
    shape: const BeveledRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      side: BorderSide(
        color: Colors.white,
        width: 2,
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
