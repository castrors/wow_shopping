part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistState {}

final class WishlistInitial extends WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  final List<ProductItem> products;

  WishlistLoaded(this.products);
}

final class WishlistFailure extends WishlistState {}
