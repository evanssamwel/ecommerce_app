import 'cart_item.dart';

enum OrderStatus {
  processing,
  shipped,
  outForDelivery,
  delivered,
}

class TrackingStep {
  final String title;
  final String subtitle;
  final String timestamp;
  final bool isCompleted;

  const TrackingStep({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isCompleted,
  });
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double shipping;
  final double tax;
  final double total;
  final DateTime createdAt;
  final OrderStatus status;
  final String shippingAddress;
  final String paymentMethod;
  final String deliveryType;
  final List<TrackingStep> trackingSteps;

  const OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.createdAt,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.deliveryType,
    required this.trackingSteps,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}
