import 'package:cocktail_app/src/domain/models/profile.dart';
import 'package:flutter/material.dart';


class ProfileListElementWidget extends StatelessWidget {
  final Profile profile;
  final void Function(Profile profile)? onRemove;
  final void Function(Profile profile)? onArticlePressed;

  const ProfileListElementWidget({
    Key? key,
    required this.profile,
    this.onArticlePressed,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
            start: 12, end: 12, bottom: 8, top: 8),
        height: MediaQuery.of(context).size.width / 4.0,
        child: Row(
          children: [
            _buildImage(context),
            _buildTitleAndDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
          ),
          child: Image.network(
            profile.picture,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return const Center(
                child: Text(
                  '404\nNOT FOUND',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              profile.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Butler',
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),

            // Description
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '',  // TODO: Description
                  maxLines: 2,
                ),
              ),
            ),

            // Datetime
            /* const Row(
              children: [
                Icon(Ionicons.time_outline, size: 16),
                SizedBox(width: 4),
                Text(
                  '', // Todo: Extra relevant data
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ), */
          ],
        ),
      ),
    );
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed?.call(profile);
    }
  }

  void _onRemove() {
    if (onRemove != null) {
      onRemove?.call(profile);
    }
  }
}