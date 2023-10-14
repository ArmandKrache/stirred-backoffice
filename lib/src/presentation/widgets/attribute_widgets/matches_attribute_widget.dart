import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:flutter/material.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class MatchesAttributeWidget extends StatelessWidget {
  final List<IngredientMatch> matches;

  const MatchesAttributeWidget({
    super.key,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGenericAttributeWidget(
      title: "Matches with",
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 64, maxWidth: 256),
        child: Text(
            matches.map((obj) => obj.name).join(', '),
    ),
      ),
    );
  }
}