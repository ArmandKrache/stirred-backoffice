import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/config/themes/app_themes.dart';
import 'package:cocktail_app/src/domain/models/glass.dart';
import 'package:cocktail_app/src/domain/repositories/api_repository.dart';
import 'package:cocktail_app/src/locator.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_create_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/glasses/glasses_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/ingredients/ingredient_details_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/ingredients/ingredients_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/profiles/profiles_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/remote_login/remote_login_cubit.dart';
import 'package:cocktail_app/src/presentation/cubits/root_navigation/root_navigation_cubit.dart';
import 'package:cocktail_app/src/utils/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('fr')],
      path: 'assets/translations/',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RootNavigationCubit()),
        BlocProvider(create: (context) => RemoteLoginCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => ProfilesCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => GlassesCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => GlassCreateCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => GlassDetailsCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => IngredientsCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => IngredientDetailsCubit(
          locator<ApiRepository>(),)
        ),
      ],
      child: OKToast(child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
        title: appTitle,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.light,
      )),
    );
  }
}