part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent {}

final class WishlistFetchRequested extends WishlistEvent {}

final class WishlistItemAdded extends WishlistEvent {
  final String productId;

  WishlistItemAdded(this.productId);
}

final class WishlistItemRemoved extends WishlistEvent {
  final String productId;

  WishlistItemRemoved(this.productId);
}
