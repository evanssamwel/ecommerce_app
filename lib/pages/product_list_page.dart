import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sample_data.dart';
import '../providers/shop_provider.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _sortLabel(SortOption option) {
    switch (option) {
      case SortOption.featured:
        return 'Featured';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.highestRated:
        return 'Highest Rated';
      case SortOption.biggestDiscount:
        return 'Biggest Discount';
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'All':
        return Icons.grid_view_rounded;
      case 'Footwear':
        return Icons.directions_run_rounded;
      case 'Electronics':
        return Icons.headphones_rounded;
      case 'Apparel':
        return Icons.checkroom_rounded;
      case 'Accessories':
        return Icons.watch_rounded;
      case 'Home & Living':
        return Icons.coffee_maker_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();
    final products = shop.filteredProducts;
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width >= 1150
        ? 4
        : width >= 820
            ? 3
            : 2;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Promotional Hero Banner
                    _buildPromoHeroBanner(context, shop),
                    const SizedBox(height: 20),

                    // Search Bar + Sort & Filter Controls
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: width >= 720 ? 420 : double.infinity,
                          child: TextField(
                            controller: _searchController,
                            onChanged: shop.setSearchQuery,
                            decoration: InputDecoration(
                              hintText:
                                  'Search brands, sneakers, headphones, watches...',
                              prefixIcon: const Icon(Icons.search_rounded),
                              suffixIcon: shop.searchQuery.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        shop.setSearchQuery('');
                                      },
                                      icon: const Icon(Icons.clear_rounded),
                                    )
                                  : null,
                              filled: true,
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        // Sort Dropdown
                        PopupMenuButton<SortOption>(
                          onSelected: shop.setSortOption,
                          itemBuilder: (ctx) => SortOption.values
                              .map(
                                (opt) => PopupMenuItem(
                                  value: opt,
                                  child: Row(
                                    children: [
                                      Icon(
                                        shop.sortOption == opt
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        size: 18,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(_sortLabel(opt)),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sort_rounded, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  _sortLabel(shop.sortOption),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ),
                        ),
                        // On-Sale Filter Chip
                        FilterChip(
                          label: const Text('On Sale Only'),
                          selected: shop.onlyOnSale,
                          onSelected: (v) => shop.setFilters(onlyOnSale: v),
                        ),
                        // 4.8+ Rating Filter Chip
                        FilterChip(
                          label: const Text('4.8★ & Up'),
                          selected: shop.minRating >= 4.8,
                          onSelected: (v) =>
                              shop.setFilters(minRating: v ? 4.8 : 0.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Category Horizontal Scroller
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: productCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = productCategories[index];
                          final isSelected = shop.selectedCategory == cat;
                          return ChoiceChip(
                            avatar: Icon(
                              _categoryIcon(cat),
                              size: 17,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.primary,
                            ),
                            label: Text(
                              cat,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : null,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: theme.colorScheme.primary,
                            showCheckmark: false,
                            onSelected: (_) => shop.setCategory(cat),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Results Count Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${shop.selectedCategory} Collection (${products.length} products)',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (shop.selectedCategory != 'All' ||
                            shop.searchQuery.isNotEmpty ||
                            shop.onlyOnSale ||
                            shop.minRating > 0)
                          TextButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              shop.resetFilters();
                            },
                            icon: const Icon(Icons.restart_alt_rounded, size: 18),
                            label: const Text('Reset Filters'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (products.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 56,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No matching products found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      _searchController.clear();
                      shop.resetFilters();
                    },
                    child: const Text('Clear all filters'),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(product: products[index]),
                childCount: products.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPromoHeroBanner(BuildContext context, ShopProvider shop) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 16,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade400,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'SEASON FLASH EVENT • EXTRA 20% OFF',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Curated Performance Gear & Lifestyle Essentials',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use code SAVE20 at checkout for an extra 20% discount + free standard shipping on orders over \$150.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  shop.applyPromoCode('SAVE20');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Promo code SAVE20 (20% OFF) automatically applied to your bag!',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.local_offer_rounded, size: 18),
                label: Text(
                  shop.appliedPromoCode == 'SAVE20'
                      ? 'SAVE20 Applied ✓'
                      : 'Claim SAVE20',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
