// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({required WishlistRepo repository})
      : _repository = repository,
        super(WishlistInitial()) {
    on<WishlistFetchRequested>(_onWishlistFetchRequested);
    on<WishlistItemAdded>(_onWishlistItemAdded);
    on<WishlistItemRemoved>(_onWishlistItemRemoved);
  }
  final WishlistRepo _repository;

  Future<void> _onWishlistFetchRequested(
    WishlistFetchRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());

    await emit.forEach(
      _repository.streamWishlistItems,
      onData: (wishlistItems) {
        return WishlistLoaded(wishlistItems);
      },
      onError: (_, __) => WishlistFailure(),
    );
  }

  Future<void> _onWishlistItemAdded(
    WishlistItemAdded event,
    Emitter<WishlistState> emit,
  ) async {
    _repository.addToWishlist(event.productId);
  }

  Future<void> _onWishlistItemRemoved(
    WishlistItemRemoved event,
    Emitter<WishlistState> emit,
  ) async {
    _repository.removeToWishlist(event.productId);
  }
}
