import 'package:flutter/material.dart';
import 'package:stirred_backoffice/core/constants/spacing.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class DrinkRow extends StatelessWidget {
  const DrinkRow({
    super.key, 
    required this.drink,
    required this.onTap,
  });

  final Drink drink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            // Picture
            SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: drink.picture != null
                    ? Image.network(
                        drink.picture!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.local_bar, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.local_bar, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(width: StirSpacings.small16),
            // Name and ID
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    drink.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drink.id,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Author
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StirSpacings.small16),
                child: Text(drink.author?.name ?? 'Unknown'),
              ),
            ),
            // Actions
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade200,
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onTap,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      // TODO: Implement delete
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 