import 'package:flutter/material.dart';

// Screens
import 'screens/delivery_address_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/customer_service_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/support_chat_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/notification_manager_screen.dart';

class Routes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const products = '/products';
  static const productDetail = '/product_detail';
  static const orders = '/orders';
  static const settings = '/settings';
  static const customerService = '/customer_service';
  static const subscriptions = '/subscriptions';
  static const supportChat = '/support_chat';
  static const deliveryAddress = '/delivery_address';
  static const notificationManager = '/notification-manager';

  // Admin
  static const adminDashboard = '/admin_dashboard';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.products:
        return MaterialPageRoute(builder: (_) => const ProductsScreen());
      case Routes.productDetail:
        return MaterialPageRoute(builder: (_) => const ProductDetailScreen());
      case Routes.orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case Routes.customerService:
        return MaterialPageRoute(builder: (_) => const CustomerServiceScreen());
      case Routes.subscriptions:
        return MaterialPageRoute(builder: (_) => const SubscriptionsScreen());
      case Routes.supportChat:
        return MaterialPageRoute(builder: (_) => const SupportChatScreen());
      case Routes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case Routes.deliveryAddress:
        return MaterialPageRoute(builder: (_) => const DeliveryAddressScreen());
      case Routes.notificationManager:
        return MaterialPageRoute(builder: (_) => const NotificationManagerScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
