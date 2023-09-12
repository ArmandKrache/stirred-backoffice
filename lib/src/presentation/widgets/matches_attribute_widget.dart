import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/presentation/widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/utils/constants/strings.dart';
import 'package:flutter/material.dart';

class MatchesAttributeWidget extends StatelessWidget {
  final List<String> matches;

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
        child: Text(matches.toString()), /*ListView.builder(
          shrinkWrap: true,
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return Text(matches[index]);
          },
        ),*/
      ),
    );
  }
}