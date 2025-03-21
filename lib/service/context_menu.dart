import 'package:flutter/material.dart';

Future<T?> showContextMenu<T>({
  required BuildContext context,
  required Offset offset,
  required List<PopupMenuEntry<T>> items,
}) async =>
    await showMenu<T>(
      shape: BeveledRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
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
