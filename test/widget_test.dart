import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/providers/shop_provider.dart';

void main() {
  testWidgets('LuxeShop storefront loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ShopProvider(),
        child: const EcommerceApp(),
      ),
    );

    expect(find.text('LuxeShop'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
  });
}
