import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/domain/models/drink.dart';
import 'package:cocktail_app/src/presentation/views/drink_details_view.dart';
import 'package:cocktail_app/src/presentation/views/homepage_view.dart';
import 'package:cocktail_app/src/presentation/views/login_view.dart';
import 'package:cocktail_app/src/presentation/views/root_view.dart';
import 'package:cocktail_app/src/presentation/views/saved_drink_view.dart';
import 'package:flutter/cupertino.dart';
part 'app_router.gr.dart';


@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends _$AppRouter {

    @override
    List<AutoRoute> get routes => [
        AutoRoute(page: RootRoute.page),
        AutoRoute(page: LoginRoute.page, initial: true)
    ];
}

final appRouter = AppRouter();