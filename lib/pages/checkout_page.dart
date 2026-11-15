import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import 'orders_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _selectedAddressIndex = 0;
  int _selectedPaymentIndex = 0;
  bool _isPlacingOrder = false;

  void _showNewAddressModal(BuildContext context, ShopProvider shop) {
    final labelCtrl = TextEditingController(text: 'Work');
    final streetCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final phoneCtrl = TextEditingController(text: shop.userPhone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Shipping Address'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelCtrl,
                decoration: const InputDecoration(
                  labelText: 'Label (e.g. Home, Office)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: streetCtrl,
                decoration: const InputDecoration(
                  labelText: 'Street Address & Apt',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityCtrl,
                decoration: const InputDecoration(
                  labelText: 'City, State & ZIP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (streetCtrl.text.trim().isEmpty) return;
              shop.addAddress(
                SavedAddress(
                  id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
                  label: labelCtrl.text.trim(),
                  recipient: shop.userName,
                  street: streetCtrl.text.trim(),
                  cityStateZip: cityCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                ),
              );
              setState(() {
                _selectedAddressIndex = shop.addresses.length - 1;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOrder(BuildContext context, ShopProvider shop) async {
    setState(() => _isPlacingOrder = true);
    await Future.delayed(const Duration(milliseconds: 650));

    final chosenAddress =
        shop.addresses[_selectedAddressIndex % shop.addresses.length];
    final paymentLabels = [
      ...shop.paymentCards
          .map((c) => '${c.brand} ending in ${c.last4} (Exp ${c.expiry})'),
      'Apple Pay / Google Pay Express',
      'Cash on Delivery',
    ];
    final chosenPayment =
        paymentLabels[_selectedPaymentIndex % paymentLabels.length];

    final order = shop.placeOrder(
      shippingAddress: chosenAddress.fullAddress,
      paymentMethod: chosenPayment,
    );

    if (!context.mounted) return;
    setState(() => _isPlacingOrder = false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 56,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Order ${order.id} has been placed for \$${order.total.toStringAsFixed(2)}.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Text(
              'Delivering to: ${order.shippingAddress}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Back to Shop'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const OrdersPage(standalone: true),
                        ),
                      );
                    },
                    child: const Text('Track Order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final theme = Theme.of(context);

    if (shop.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('Your cart is empty.')),
      );
    }

    final paymentOptions = [
      ...shop.paymentCards.map(
        (c) => (
          title: '${c.brand} •••• ${c.last4}',
          subtitle: 'Expires ${c.expiry} • ${c.cardholder}',
          icon: Icons.credit_card_rounded,
        ),
      ),
      (
        title: 'Apple Pay / Google Pay',
        subtitle: 'One-tap biometric authentication',
        icon: Icons.account_balance_wallet_outlined,
      ),
      (
        title: 'Pay on Delivery',
        subtitle: 'Cash or contactless terminal at your door',
        icon: Icons.payments_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Secure Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Shipping Address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '1. Shipping Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showNewAddressModal(context, shop),
                      icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                      label: const Text('New Address'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...List.generate(shop.addresses.length, (idx) {
                  final addr = shop.addresses[idx];
                  final isSelected = idx == _selectedAddressIndex;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.grey.withValues(alpha: 0.25),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<int>(
                      value: idx,
                      groupValue: _selectedAddressIndex,
                      onChanged: (v) =>
                          setState(() => _selectedAddressIndex = v ?? 0),
                      title: Row(
                        children: [
                          Text(
                            addr.label,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${addr.recipient})',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text('${addr.fullAddress}\n${addr.phone}'),
                      isThreeLine: true,
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // 2. Delivery Speed
                const Text(
                  '2. Delivery Speed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _deliveryCard(
                        context,
                        title: 'Standard Ground',
                        subtitle: '3–5 Business Days',
                        price: shop.subtotal >= 150 ? 'FREE' : '\$9.99',
                        selected: !shop.expressShipping,
                        onTap: () => shop.setExpressShipping(false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _deliveryCard(
                        context,
                        title: 'Express Air',
                        subtitle: '1–2 Business Days',
                        price: '\$14.99',
                        selected: shop.expressShipping,
                        onTap: () => shop.setExpressShipping(true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. Payment Method
                const Text(
                  '3. Payment Method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ...List.generate(paymentOptions.length, (idx) {
                  final opt = paymentOptions[idx];
                  final isSelected = idx == _selectedPaymentIndex;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.grey.withValues(alpha: 0.25),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: RadioListTile<int>(
                      value: idx,
                      groupValue: _selectedPaymentIndex,
                      onChanged: (v) =>
                          setState(() => _selectedPaymentIndex = v ?? 0),
                      secondary: Icon(opt.icon, color: theme.colorScheme.primary),
                      title: Text(
                        opt.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(opt.subtitle),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // 4. Final Review Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Review (${shop.cartItemCount} items)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...shop.cartItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.product.name} (${item.selectedSize})',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Due',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
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
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _isPlacingOrder
                                ? null
                                : () => _submitOrder(context, shop),
                            icon: _isPlacingOrder
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.verified_user_outlined),
                            label: Text(
                              _isPlacingOrder
                                  ? 'Authorizing Order...'
                                  : 'Place Order • \$${shop.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deliveryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String price,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : Colors.grey.withValues(alpha: 0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
