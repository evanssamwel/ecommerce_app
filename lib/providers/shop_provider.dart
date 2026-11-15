import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/sample_data.dart';

enum SortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  highestRated,
  biggestDiscount,
}

class SavedAddress {
  final String id;
  final String label;
  final String recipient;
  final String street;
  final String cityStateZip;
  final String phone;
  bool isDefault;

  SavedAddress({
    required this.id,
    required this.label,
    required this.recipient,
    required this.street,
    required this.cityStateZip,
    required this.phone,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $cityStateZip';
}

class SavedPaymentCard {
  final String id;
  final String brand;
  final String last4;
  final String expiry;
  final String cardholder;
  bool isDefault;

  SavedPaymentCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.cardholder,
    this.isDefault = false,
  });
}

class ShopProvider extends ChangeNotifier {
  final List<Product> _products = List<Product>.from(sampleProducts);
  final Map<String, List<ProductReview>> _customReviews = {};

  String _searchQuery = '';
  String _selectedCategory = 'All';
  SortOption _sortOption = SortOption.featured;
  bool _onlyOnSale = false;
  double _minRating = 0.0;
  bool _isDarkMode = false;

  final Set<String> _wishlistIds = {'2', '4'};
  final List<CartItem> _cart = [
    CartItem(
      product: sampleProducts[0],
      quantity: 1,
      selectedSize: sampleProducts[0].sizes[2],
      selectedColor: sampleProducts[0].colors[0].name,
    ),
  ];

  String _appliedPromoCode = '';
  bool _expressShipping = false;

  // User profile state
  String userName = 'Alex Rivera';
  String userEmail = 'alex.rivera@luxeshop.io';
  String userPhone = '+1 (555) 234-8910';
  int rewardPoints = 1450;

  final List<SavedAddress> addresses = [
    SavedAddress(
      id: 'addr1',
      label: 'Home',
      recipient: 'Alex Rivera',
      street: '742 Evergreen Terrace, Apt 4B',
      cityStateZip: 'San Francisco, CA 94107',
      phone: '+1 (555) 234-8910',
      isDefault: true,
    ),
    SavedAddress(
      id: 'addr2',
      label: 'Studio Office',
      recipient: 'Alex Rivera',
      street: '450 Mission Street, Suite 1200',
      cityStateZip: 'San Francisco, CA 94105',
      phone: '+1 (555) 890-4412',
      isDefault: false,
    ),
  ];

  final List<SavedPaymentCard> paymentCards = [
    SavedPaymentCard(
      id: 'card1',
      brand: 'Visa',
      last4: '4242',
      expiry: '08/29',
      cardholder: 'ALEX RIVERA',
      isDefault: true,
    ),
    SavedPaymentCard(
      id: 'card2',
      brand: 'Mastercard',
      last4: '8819',
      expiry: '11/28',
      cardholder: 'ALEX RIVERA',
      isDefault: false,
    ),
  ];

  late final List<OrderModel> _orders = [
    OrderModel(
      id: 'ORD-94821',
      items: [
        CartItem(
          product: sampleProducts[1],
          quantity: 1,
          selectedSize: 'Standard',
          selectedColor: 'Matte Black',
        ),
        CartItem(
          product: sampleProducts[5],
          quantity: 1,
          selectedSize: 'Tactile Brown',
          selectedColor: 'Space Gray',
        ),
      ],
      subtotal: 458.00,
      discount: 45.80,
      shipping: 0.00,
      tax: 32.98,
      total: 445.18,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      status: OrderStatus.outForDelivery,
      shippingAddress: '742 Evergreen Terrace, Apt 4B, San Francisco, CA 94107',
      paymentMethod: 'Visa ending in 4242',
      deliveryType: 'Express Air (1-2 Days)',
      trackingSteps: const [
        TrackingStep(
          title: 'Order Confirmed',
          subtitle: 'Payment verified & order sent to fulfillment center',
          timestamp: 'Yesterday, 9:14 AM',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Packed & Quality Checked',
          subtitle: 'Package sealed at Bay Area Hub #3',
          timestamp: 'Yesterday, 2:40 PM',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'In Transit',
          subtitle: 'Arrived at San Francisco regional sort facility',
          timestamp: 'Today, 6:15 AM',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Out for Delivery',
          subtitle: 'Courier Leo M. is 4 stops away',
          timestamp: 'Today, 11:30 AM',
          isCompleted: true,
        ),
      ],
    ),
    OrderModel(
      id: 'ORD-88310',
      items: [
        CartItem(
          product: sampleProducts[3],
          quantity: 1,
          selectedSize: '40mm',
          selectedColor: 'Gunmetal / Brown Leather',
        ),
      ],
      subtotal: 185.00,
      discount: 0.00,
      shipping: 0.00,
      tax: 14.80,
      total: 199.80,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
      status: OrderStatus.delivered,
      shippingAddress: '450 Mission Street, Suite 1200, San Francisco, CA 94105',
      paymentMethod: 'Mastercard ending in 8819',
      deliveryType: 'Standard Ground (Free)',
      trackingSteps: const [
        TrackingStep(
          title: 'Order Confirmed',
          subtitle: 'Order received and confirmed',
          timestamp: '12 days ago',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Shipped via FedEx Priority',
          subtitle: 'Tracking #FX-901283912',
          timestamp: '11 days ago',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Delivered',
          subtitle: 'Signed for at front desk reception',
          timestamp: '9 days ago',
          isCompleted: true,
        ),
      ],
    ),
  ];

  // Getters
  List<Product> get allProducts => List.unmodifiable(_products);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  SortOption get sortOption => _sortOption;
  bool get onlyOnSale => _onlyOnSale;
  double get minRating => _minRating;
  bool get isDarkMode => _isDarkMode;
  String get appliedPromoCode => _appliedPromoCode;
  bool get expressShipping => _expressShipping;
  List<CartItem> get cartItems => List.unmodifiable(_cart);
  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<Product> get wishlistProducts =>
      _products.where((p) => _wishlistIds.contains(p.id)).toList();

  int get wishlistCount => _wishlistIds.length;

  int get cartItemCount =>
      _cart.fold(0, (previousValue, item) => previousValue + item.quantity);

  List<Product> get filteredProducts {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = _products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      final matchesSale = !_onlyOnSale || product.isOnSale;
      final matchesRating = product.rating >= _minRating;
      return matchesCategory && matchesQuery && matchesSale && matchesRating;
    }).toList();

    switch (_sortOption) {
      case SortOption.featured:
        filtered.sort((a, b) {
          if (a.isFeatured != b.isFeatured) {
            return a.isFeatured ? -1 : 1;
          }
          return b.rating.compareTo(a.rating);
        });
      case SortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.highestRated:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.biggestDiscount:
        filtered.sort(
            (a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    }
    return filtered;
  }

  List<ProductReview> getReviewsForProduct(Product product) {
    final extra = _customReviews[product.id] ?? const [];
    return [...extra, ...product.reviews];
  }

  void addReview(String productId, String author, double rating, String comment) {
    final list = _customReviews.putIfAbsent(productId, () => []);
    list.insert(
      0,
      ProductReview(
        id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
        author: author.trim().isEmpty ? userName : author.trim(),
        rating: rating,
        date: 'Just now',
        comment: comment.trim(),
        verified: true,
      ),
    );
    notifyListeners();
  }

  // Filter & Theme Actions
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void setFilters({bool? onlyOnSale, double? minRating}) {
    if (onlyOnSale != null) _onlyOnSale = onlyOnSale;
    if (minRating != null) _minRating = minRating;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    _sortOption = SortOption.featured;
    _onlyOnSale = false;
    _minRating = 0.0;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Wishlist Actions
  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  void toggleWishlist(String productId) {
    if (_wishlistIds.contains(productId)) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    notifyListeners();
  }

  // Cart Actions
  void addToCart(
    Product product, {
    int quantity = 1,
    String? size,
    String? color,
  }) {
    final chosenSize =
        size ?? (product.sizes.isNotEmpty ? product.sizes.first : 'Standard');
    final chosenColor = color ??
        (product.colors.isNotEmpty ? product.colors.first.name : 'Default');

    final existingIndex = _cart.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == chosenSize &&
          item.selectedColor == chosenColor,
    );

    if (existingIndex >= 0) {
      _cart[existingIndex].quantity += quantity;
    } else {
      _cart.add(
        CartItem(
          product: product,
          quantity: quantity,
          selectedSize: chosenSize,
          selectedColor: chosenColor,
        ),
      );
    }
    notifyListeners();
  }

  void updateCartQuantity(CartItem item, int delta) {
    final index = _cart.indexOf(item);
    if (index == -1) return;
    final newQty = _cart[index].quantity + delta;
    if (newQty <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index].quantity = newQty;
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    _appliedPromoCode = '';
    notifyListeners();
  }

  void setExpressShipping(bool value) {
    _expressShipping = value;
    notifyListeners();
  }

  // Promo Code & Totals
  String? applyPromoCode(String rawCode) {
    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) {
      _appliedPromoCode = '';
      notifyListeners();
      return null;
    }
    if (code == 'SAVE20' || code == 'WELCOME10' || code == 'FREESHIP') {
      _appliedPromoCode = code;
      notifyListeners();
      return null; // success
    }
    return 'Invalid code. Try SAVE20, WELCOME10, or FREESHIP.';
  }

  void removePromoCode() {
    _appliedPromoCode = '';
    notifyListeners();
  }

  double get subtotal =>
      _cart.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount {
    if (_cart.isEmpty) return 0.0;
    if (_appliedPromoCode == 'SAVE20') return subtotal * 0.20;
    if (_appliedPromoCode == 'WELCOME10') return subtotal * 0.10;
    return 0.0;
  }

  double get shippingCost {
    if (_cart.isEmpty) return 0.0;
    if (_appliedPromoCode == 'FREESHIP') return 0.0;
    if (_expressShipping) return 14.99;
    return subtotal >= 150.0 ? 0.0 : 9.99;
  }

  double get taxAmount {
    if (_cart.isEmpty) return 0.0;
    final taxable = (subtotal - discountAmount).clamp(0.0, double.infinity);
    return taxable * 0.08;
  }

  double get totalAmount {
    if (_cart.isEmpty) return 0.0;
    return (subtotal - discountAmount + shippingCost + taxAmount)
        .clamp(0.0, double.infinity);
  }

  // Checkout -> Place Order
  OrderModel placeOrder({
    required String shippingAddress,
    required String paymentMethod,
  }) {
    final orderItems = _cart
        .map(
          (item) => CartItem(
            product: item.product,
            quantity: item.quantity,
            selectedSize: item.selectedSize,
            selectedColor: item.selectedColor,
          ),
        )
        .toList();

    final order = OrderModel(
      id: 'ORD-${10000 + DateTime.now().millisecondsSinceEpoch % 89999}',
      items: orderItems,
      subtotal: subtotal,
      discount: discountAmount,
      shipping: shippingCost,
      tax: taxAmount,
      total: totalAmount,
      createdAt: DateTime.now(),
      status: OrderStatus.processing,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      deliveryType: _expressShipping
          ? 'Express Air (1-2 Business Days)'
          : 'Standard Ground (3-5 Business Days)',
      trackingSteps: const [
        TrackingStep(
          title: 'Order Placed',
          subtitle: 'We have received your order and payment authorization',
          timestamp: 'Just now',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Preparing for Shipment',
          subtitle: 'Warehouse team is picking and packing your items',
          timestamp: 'In progress',
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Out for Delivery',
          subtitle: 'Courier dispatch upon package scan',
          timestamp: 'Pending',
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Delivered',
          subtitle: 'Estimated arrival within delivery window',
          timestamp: 'Pending',
          isCompleted: false,
        ),
      ],
    );

    _orders.insert(0, order);
    rewardPoints += (order.total * 2).round();
    clearCart();
    notifyListeners();
    return order;
  }

  void addAddress(SavedAddress address) {
    if (address.isDefault) {
      for (final a in addresses) {
        a.isDefault = false;
      }
    }
    addresses.add(address);
    notifyListeners();
  }
}
