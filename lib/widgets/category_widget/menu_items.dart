import 'package:flutter/material.dart';
import 'package:nullife_feeddo/models/menu_item.dart';

class MenuItems {
  static const List<MenuItem> categoryMenu = [
    itemEdit,
    itemDelete,
  ];

  static const itemEdit = MenuItem(
    icon: Icons.edit,
    text: 'Edit',
  );

  static const itemDelete = MenuItem(
    icon: Icons.delete,
    text: 'Delete',
  );
}
