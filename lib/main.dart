import 'package:stirred_backoffice/src/config/router/app_router.dart';
import 'package:stirred_backoffice/src/config/themes/app_themes.dart';
import 'package:stirred_backoffice/src/presentation/cubits/drinks/drink_create_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/drinks/drink_details_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/drinks/drinks_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/glasses/glass_create_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/glasses/glass_details_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/glasses/glasses_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/ingredients/ingredient_details_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/ingredients/ingredients_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/login/login_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/profiles/profiles_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/recipes/recipe_create_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/recipes/recipe_details_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/recipes/recipes_cubit.dart';
import 'package:stirred_backoffice/src/presentation/cubits/root_navigation/root_navigation_cubit.dart';
import 'package:stirred_backoffice/src/utils/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';


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
        BlocProvider(create: (context) => LoginCubit(
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
        BlocProvider(create: (context) => RecipesCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => RecipeCreateCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => RecipeDetailsCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => DrinksCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => DrinkCreateCubit(
          locator<ApiRepository>(),)
        ),
        BlocProvider(create: (context) => DrinkDetailsCubit(
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