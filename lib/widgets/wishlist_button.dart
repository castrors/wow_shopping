import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

@immutable
class WishlistButton extends StatelessWidget {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    // FIXME: I'm providing bloc in the main_dev.dart file already, and I notice
    // that if I don't provide here again it doesn't work. Why?
    return BlocProvider<WishlistBloc>(
      create: (context) => WishlistBloc(repository: context.wishlistRepo)
        ..add(WishlistFetchRequested()),
      child: WishlistButtonView(item: item),
    );
  }
}

class WishlistButtonView extends StatelessWidget {
  const WishlistButtonView({
    super.key,
    required this.item,
  });

  final ProductItem item;

  void _onTogglePressed(BuildContext context, bool value) {
    if (value) {
      context.read<WishlistBloc>().add(WishlistItemAdded(item.id));
    } else {
      context.read<WishlistBloc>().add(WishlistItemRemoved(item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      // buildWhen: (previous, current) => current is WishlistLoaded,
      builder: (context, state) {
        // FIXME: The first time running it the state is wrong. If it does
        // have a wishlist in the list, it will show the empty heart for all.
        final isWishlisted = switch (state) {
          WishlistLoaded(products: final products) =>
            products.any((p) => p.id == item.id),
          _ => false,
        };

        return IconButton(
          onPressed: () => _onTogglePressed(context, !isWishlisted),
          icon: AppIcon(
            iconAsset: isWishlisted //
                ? Assets.iconHeartFilled
                : Assets.iconHeartEmpty,
            color: isWishlisted //
                ? AppTheme.of(context).appColor
                : const Color(0xFFD0D0D0),
          ),
        );
      },
    );
  }
}
