import 'package:flutter/material.dart';

/// For handling image file path
extension CurrencyAmount on double {
  String get toRmCurrency {
    return 'RM ${toStringAsFixed(2)}';
  }
}

/// For empty space handling
extension EmptyPadding on num {
  SizedBox get heightBox => SizedBox(height: toDouble());

  SizedBox get widthBox => SizedBox(width: toDouble());

  // Sliver empty space
  SliverToBoxAdapter get sliverEmptyBox {
    return SliverToBoxAdapter(
      child: SizedBox(height: toDouble()),
    );
  }
}
