import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/app.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/wishlist/bloc/wishlist_bloc.dart';

void main() {
  runApp(
    BlocProvider<WishlistBloc>(
      create: (context) => WishlistBloc(
        repository: context.wishlistRepo,
      )..add(WishlistFetchRequested()),
      child: const ShopWowApp(
        config: AppConfig(
          env: AppEnv.dev,
        ),
      ),
    ),
  );
}
