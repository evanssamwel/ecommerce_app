# 🛍️ LuxeShop — Modern Flutter E-Commerce App

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.9+-0175C2?logo=dart&logoColor=white)
![State Management](https://img.shields.io/badge/State-Provider-4CAF50)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android%20%7C%20iOS%20%7C%20Windows%20%7C%20macOS-blueviolet)

**LuxeShop** is a full-featured, cross-platform e-commerce storefront built with **Flutter**, **Material 3**, and **Provider**. It delivers a complete shopping flow—from product discovery, filtering, and interactive variants to promo-enabled cart management, checkout, and real-time shipment tracking.

---

## ✨ Key Features

### 🏪 Storefront & Product Discovery
- **Promotional Flash Banner**: Interactive hero banner with one-tap promo voucher activation (`SAVE20`).
- **Smart Search & Filtering**: Live search across product names, brands, categories, and descriptions.
- **Category Navigation**: Filter across *Footwear*, *Electronics*, *Apparel*, *Accessories*, and *Home & Living*.
- **Dynamic Sorting & Quick Filters**: Sort by *Featured*, *Price: Low to High*, *Price: High to Low*, *Highest Rated*, or *Biggest Discount*, plus toggle *On Sale Only* and *4.8★ & Up*.
- **Responsive Grid**: Adapts seamlessly from 2 columns on mobile to 3–4 columns on tablet and desktop web viewports.

### 🔍 Interactive Product Details
- **Multi-Angle Image Gallery**: Smooth `Hero` animations and interactive thumbnail switcher.
- **Variant Selection**: Visual color swatches, size/configuration chips, stock indicator, and quantity stepper.
- **Customer Reviews**: View verified customer ratings and submit new reviews directly in the app.
- **Instant Actions**: **Add to Cart** with toast confirmation or **Buy Now** to jump straight to checkout.

### 🛒 Shopping Bag & Promo Engine
- **Free Shipping Progress**: Dynamic banner tracking progress toward the \$150 free standard shipping threshold.
- **Promo Code Support**: Built-in discount engine supporting one-tap or manual voucher codes:

| Promo Code | Benefit |
| :--- | :--- |
| `SAVE20` | **20% OFF** entire order subtotal |
| `WELCOME10` | **10% OFF** any order |
| `FREESHIP` | **Free Shipping** on Standard or Express delivery |

- **Live Price Breakdown**: Automatic calculation of subtotal, promo discounts, shipping tier (*Standard Ground* vs. *Express Air*), and estimated tax (8%).

### 💳 Secure Checkout & Live Order Tracking
- **Address Management**: Choose from saved shipping addresses or add a new delivery address on the fly.
- **Flexible Payment Options**: Saved credit cards (Visa / Mastercard), Apple Pay / Google Pay Express, or Pay on Delivery.
- **Order History & Timeline**: Expandable step-by-step shipment tracking (*Order Confirmed* → *Packed* → *In Transit* → *Out for Delivery* → *Delivered*) and one-click **Buy Again** reordering.

### ❤️ Wishlist, VIP Profile & Theming
- **Wishlist**: Save favorite products from any card or detail view, or move all saved items into the shopping bag with a single tap.
- **User Account & Loyalty**: Track total orders, wishlisted items, and Platinum VIP reward points (+2 pts per \$1 spent).
- **Light & Dark Mode**: Instant theme switching powered by Material 3 color schemes and Google Fonts (`Poppins`).

---

## 📂 Project Structure

```text
lib/
├── main.dart                      # App entrypoint, theme configuration & bottom navigation shell
├── models/
│   ├── cart_item.dart             # Shopping bag line-item model (product, size, color, qty)
│   ├── order.dart                 # Order & shipment tracking step models
│   ├── product.dart               # Product, color swatch & customer review models
│   └── sample_data.dart           # Curated catalog of 12 products across 5 categories
├── pages/
│   ├── cart_page.dart             # Shopping bag, promo code input & order summary
│   ├── checkout_page.dart         # Address selection, delivery speed, payment & order confirmation
│   ├── orders_page.dart           # Order history & expandable live shipment timeline
│   ├── product_detail_page.dart   # Gallery, variant selectors, specs & customer reviews
│   ├── product_list_page.dart     # Hero banner, search, category pills, filters & responsive grid
│   ├── profile_page.dart          # VIP profile, stats, promo wallet & dark mode toggle
│   └── wishlist_page.dart         # Saved favorites grid & bulk "Add All to Bag" action
├── providers/
│   └── shop_provider.dart         # Centralized ChangeNotifier state for catalog, cart, wishlist & orders
└── widgets/
    └── product_card.dart          # Reusable product card with badges, wishlist toggle & quick-add
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.9.2`)
- Chrome / Edge (for Web) or Android Studio / Xcode / Visual Studio (for Mobile & Desktop)

### Installation & Running

1. **Clone the repository**
   ```bash
   git clone https://github.com/evanssamwel/ecommerce_app.git
   cd ecommerce_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   - **Web (Chrome on port 8080):**
     ```bash
     flutter run -d chrome --web-port 8080
     ```
   - **Windows / macOS / Mobile:**
     ```bash
     flutter run
     ```

4. **Run widget tests**
   ```bash
   flutter test
   ```

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Material 3)
- **Language:** [Dart](https://dart.dev/)
- **State Management:** [`provider`](https://pub.dev/packages/provider) (`ChangeNotifierProvider`)
- **Typography:** [`google_fonts`](https://pub.dev/packages/google_fonts) (`Poppins`)
- **Vector Assets:** [`flutter_svg`](https://pub.dev/packages/flutter_svg)
