import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/features/main/widgets/bottom_nav_bar.dart';

class BottomNavbarStateNotifier extends StateNotifier<NavItem> {
  BottomNavbarStateNotifier() : super(NavItem.home);

  void gotoSection(NavItem item) {
    state = item;
  }
}

final bottomNavBarProvider =
    StateNotifierProvider<BottomNavbarStateNotifier, NavItem>(
  (ref) => BottomNavbarStateNotifier(),
);
