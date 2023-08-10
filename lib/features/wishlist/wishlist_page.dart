import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:wow_shopping/features/wishlist/widgets/wishlist_item.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WishlistBloc>(
      create: (context) => WishlistBloc(repository: context.wishlistRepo)
        ..add(WishlistFetchRequested()),
      child: const WishlistView(),
    );
  }
}

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            return switch (state) {
              WishlistInitial() => const SizedBox.shrink(),
              WishlistLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              WishlistFailure() => const Center(
                  child: Text('Error!'),
                ),
              WishlistLoaded(products: final products) =>
                WishlistContent(wishlist: products),
            };
          },
        ),
      ),
    );
  }
}

class WishlistContent extends StatefulWidget {
  const WishlistContent({super.key, required this.wishlist});

  final List<ProductItem> wishlist;

  @override
  State<WishlistContent> createState() => _WishlistContentState();
}

class _WishlistContentState extends State<WishlistContent> {
  final _selectedItems = <String>{};

  bool isSelected(ProductItem item) {
    return _selectedItems.contains(item.id);
  }

  void setSelected(ProductItem item, bool selected) {
    setState(() {
      if (selected) {
        _selectedItems.add(item.id);
      } else {
        _selectedItems.remove(item.id);
      }
    });
  }

  void toggleSelectAll() {
    final allIds = widget.wishlist.map((el) => el.id).toList();
    setState(() {
      if (_selectedItems.containsAll(allIds)) {
        _selectedItems.clear();
      } else {
        _selectedItems.addAll(allIds);
      }
    });
  }

  void _removeSelected() {
    setState(() {
      for (final selected in _selectedItems) {
        context.read<WishlistBloc>().add(WishlistItemRemoved(selected));
      }
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TopNavBar(
          title: const Text('Wishlist'),
          actions: [
            TextButton(
              onPressed: toggleSelectAll,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: const Text('Select All'),
            ),
          ],
        ),
        Expanded(
          child: MediaQuery.removeViewPadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              padding: verticalPadding12,
              itemCount: widget.wishlist.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.wishlist[index];
                return Padding(
                  padding: verticalPadding12,
                  child: WishlistItem(
                    item: item,
                    onPressed: (item) {
                      // FIXME: navigate to product details
                    },
                    selected: isSelected(item),
                    onToggleSelection: setSelected,
                  ),
                );
              },
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          alignment: Alignment.topCenter,
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: _selectedItems.isEmpty ? 0.0 : 1.0,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: appLightGreyColor,
                border: Border(
                  top: BorderSide(color: appDividerColor, width: 2.0),
                ),
              ),
              child: Padding(
                padding: allPadding24,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: _removeSelected,
                        label: 'Remove',
                        iconAsset: Assets.iconRemove,
                      ),
                    ),
                    horizontalMargin16,
                    Expanded(
                      child: AppButton(
                        onPressed: () {
                          // FIXME: implement Buy Now button
                        },
                        label: 'Buy now',
                        iconAsset: Assets.iconBuy,
                        style: AppButtonStyle.highlighted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
