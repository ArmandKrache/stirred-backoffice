import 'package:stirred_backoffice/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:flutter/material.dart';
import 'package:stirred_common_domain/stirred_common_domain.dart';

class GlassAttributeWidget extends StatelessWidget {
  final Glass glass;

  const GlassAttributeWidget({
    super.key,
    required this.glass,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGenericAttributeWidget(
      title: "Glass",
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(glass.picture, height: 96,),
          const SizedBox(width: 8,),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320, minHeight: 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(glass.name,
                  style: const TextStyle(color: Colors.deepPurple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(glass.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}