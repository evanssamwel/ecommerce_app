import 'package:flutter/material.dart';

class ProductColor {
  final String name;
  final Color color;

  const ProductColor({
    required this.name,
    required this.color,
  });
}

class ProductReview {
  final String id;
  final String author;
  final double rating;
  final String date;
  final String comment;
  final bool verified;

  const ProductReview({
    required this.id,
    required this.author,
    required this.rating,
    required this.date,
    required this.comment,
    this.verified = true,
  });
}

class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final List<String> sizes;
  final List<ProductColor> colors;
  final List<String> features;
  final List<ProductReview> reviews;
  final bool isFeatured;
  final bool isNew;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.images,
    required this.sizes,
    required this.colors,
    required this.features,
    this.reviews = const [],
    this.isFeatured = false,
    this.isNew = false,
    this.stock = 15,
  });

  String get image => images.isNotEmpty ? images.first : '';

  bool get isOnSale => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!isOnSale) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
