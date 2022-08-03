

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../config/custom_router.dart';
import '../../../enums/bottom_nav_item.dart';
import '../../../repositories/user/user_repository.dart';
import '../../create_post/create_post_screen.dart';
import '../../feed/feed_screen.dart';
import '../../notifications/notification_screen.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile/profile_screen.dart';
import '../../search/search_screen.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          )
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return const FeedScreen();
      case BottomNavItem.search:
        return const SearchScreen();
      case BottomNavItem.create:
        return const CreatePostScreen();
      case BottomNavItem.notifications:
        return const NotificationsScreen();
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(
            ProfileLoadUser(userId: context.read<AuthBloc>().state.user!.uid),
          ),
          child: ProfileScreen(),
        );
      default:
        return const Scaffold();
    }
  }
}

