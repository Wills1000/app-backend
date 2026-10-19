import 'package:flutter/material.dart';

enum PaymentMethodType { bankTransfer, opay, moniepoint, card, usdt }

class PaymentMethodModel {
  final PaymentMethodType type;
  final String title;
  final String? badgeText;
  final Widget icon;
  final Widget? trailingBadge;

  const PaymentMethodModel({
    required this.type,
    required this.title,
    required this.icon,
    this.badgeText,
    this.trailingBadge,
  });
}