import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/shop_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _promoController = TextEditingController();
  String? _promoError;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(ShopProvider shop, String code) {
    _promoController.text = code;
    final err = shop.applyPromoCode(code);
    setState(() => _promoError = err);
    if (err == null && code.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code $code applied!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final items = shop.cartItems;
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width >= 880;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Bag (${shop.cartItemCount})'),
        actions: [
          if (items.isNotEmpty)
            TextButton.icon(
              onPressed: () => shop.clearCart(),
              icon: const Icon(Icons.delete_sweep_outlined, size: 19),
              label: const Text('Clear All'),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your shopping bag is empty',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore our catalog and add items to your bag.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.explore_outlined),
                      label: const Text('Continue Shopping'),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: _buildCartItemsList(context, shop, items),
                            ),
                            const SizedBox(width: 28),
                            Expanded(
                              flex: 5,
                              child: _buildOrderSummaryCard(context, shop),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCartItemsList(context, shop, items),
                            const SizedBox(height: 24),
                            _buildOrderSummaryCard(context, shop),
                          ],
                        ),
                ),
              ),
            ),
    );
  }

  Widget _buildCartItemsList(
    BuildContext context,
    ShopProvider shop,
    List<CartItem> items,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Free shipping banner
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  shop.subtotal >= 150
                      ? 'You have unlocked FREE Standard Shipping on this order!'
                      : 'Add \$${(150 - shop.subtotal).toStringAsFixed(2)} more to unlock FREE Standard Shipping!',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...items.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withValues(alpha: 0.22)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.product.image,
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 88,
                        height: 88,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.shopping_bag_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.brand.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Option: ${item.selectedSize} • ${item.selectedColor}',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton.outlined(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      shop.updateCartQuantity(item, -1),
                                  icon: const Icon(Icons.remove, size: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                IconButton.outlined(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () =>
                                      shop.updateCartQuantity(item, 1),
                                  icon: const Icon(Icons.add, size: 16),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  tooltip: 'Remove item',
                                  onPressed: () => shop.removeFromCart(item),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context, ShopProvider shop) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            // Promo code input + quick chips
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Promo code (e.g. SAVE20)',
                      isDense: true,
                      errorText: _promoError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () => _applyPromo(shop, _promoController.text),
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: ['SAVE20', 'WELCOME10', 'FREESHIP'].map((code) {
                final isApplied = shop.appliedPromoCode == code;
                return ActionChip(
                  avatar: Icon(
                    isApplied ? Icons.check_circle : Icons.local_offer_outlined,
                    size: 15,
                  ),
                  label: Text(
                    code,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (isApplied) {
                      shop.removePromoCode();
                      _promoController.clear();
                    } else {
                      _applyPromo(shop, code);
                    }
                  },
                );
              }).toList(),
            ),
            const Divider(height: 28),

            // Shipping tier switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Express Air Delivery (1–2 Days)',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('+\$14.99 priority courier handling'),
              value: shop.expressShipping,
              onChanged: (v) => shop.setExpressShipping(v),
            ),
            const Divider(height: 24),

            _summaryRow('Subtotal', '\$${shop.subtotal.toStringAsFixed(2)}'),
            if (shop.discountAmount > 0)
              _summaryRow(
                'Discount (${shop.appliedPromoCode})',
                '-\$${shop.discountAmount.toStringAsFixed(2)}',
                valueColor: Colors.green,
              ),
            _summaryRow(
              'Shipping',
              shop.shippingCost == 0
                  ? 'FREE'
                  : '\$${shop.shippingCost.toStringAsFixed(2)}',
              valueColor: shop.shippingCost == 0 ? Colors.green : null,
            ),
            _summaryRow(
              'Estimated Tax (8%)',
              '\$${shop.taxAmount.toStringAsFixed(2)}',
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  '\$${shop.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CheckoutPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.lock_outline_rounded),
                label: const Text(
                  'Proceed to Secure Checkout',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
