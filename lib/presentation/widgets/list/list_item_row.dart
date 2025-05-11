import 'package:flutter/material.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class ListItemRow extends StatelessWidget {
  const ListItemRow({
    super.key,
    required this.children,
    required this.onTap,
    this.picture,
    this.pictureSize = 48,
    this.pictureIcon = Icons.person,
  });

  final List<Widget> children;
  final VoidCallback onTap;
  final String? picture;
  final double pictureSize;
  final IconData pictureIcon;

  @override
  Widget build(BuildContext context) {
    logger.d(picture);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: StirSpacings.small16,
          vertical: StirSpacings.small12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            if (picture != null) ...[
              SizedBox(
                width: pictureSize,
                height: pictureSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    picture!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(pictureIcon, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: StirSpacings.small16),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
} 