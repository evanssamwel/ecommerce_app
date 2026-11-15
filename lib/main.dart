import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pages/cart_page.dart';
import 'pages/orders_page.dart';
import 'pages/product_list_page.dart';
import 'pages/profile_page.dart';
import 'pages/wishlist_page.dart';
import 'providers/shop_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShopProvider(),
      child: const EcommerceApp(),
    ),
  );
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<ShopProvider, bool>((s) => s.isDarkMode);

    final baseLight = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: const Color(0xFF2563EB),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    );

    final baseDark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF3B82F6),
      scaffoldBackgroundColor: const Color(0xFF0B0F19),
    );

    return MaterialApp(
      title: 'LuxeShop — E-Commerce Store',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: baseLight.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(baseLight.textTheme),
      ),
      darkTheme: baseDark.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(baseDark.textTheme),
      ),
      home: const MainStoreShell(),
    );
  }
}

class MainStoreShell extends StatefulWidget {
  const MainStoreShell({super.key});

  @override
  State<MainStoreShell> createState() => _MainStoreShellState();
}

class _MainStoreShellState extends State<MainStoreShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    ProductListPage(),
    WishlistPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  static const List<String> _titles = [
    'LuxeShop',
    'My Wishlist',
    'Order History & Tracking',
    'My Account',
  ];

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.local_mall_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _titles[_selectedIndex],
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: shop.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: shop.toggleDarkMode,
            icon: Icon(
              shop.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 4),
            child: FilledButton.tonalIcon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              icon: Badge(
                isLabelVisible: shop.cartItemCount > 0,
                label: Text('${shop.cartItemCount}'),
                child: const Icon(Icons.shopping_bag_outlined, size: 19),
              ),
              label: Text(
                '\$${shop.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: shop.wishlistCount > 0,
              label: Text('${shop.wishlistCount}'),
              child: const Icon(Icons.favorite_border_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: shop.wishlistCount > 0,
              label: Text('${shop.wishlistCount}'),
              child: const Icon(Icons.favorite_rounded),
            ),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: shop.orders.isNotEmpty,
              label: Text('${shop.orders.length}'),
              child: const Icon(Icons.local_shipping_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: shop.orders.isNotEmpty,
              label: Text('${shop.orders.length}'),
              child: const Icon(Icons.local_shipping_rounded),
            ),
            label: 'Orders',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
