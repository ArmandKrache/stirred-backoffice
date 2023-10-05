
import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/config.dart';
import 'package:cocktail_app/src/domain/models/preferences.dart';
import 'package:cocktail_app/src/domain/models/profiles/profile.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/custom_generic_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/description_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/picture_attribute_widget.dart';
import 'package:cocktail_app/src/presentation/widgets/attribute_widgets/preferences_attribute_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const Preferences dumbPreferences = Preferences(
    id: "id",
    favorites: ["fav 1", "fav 2"],
    likes: ["like 1", "like 2", "like 3"],
    dislikes: ["dislike 1", "dislikes 2", "dislike 3", "dislike 4"],
    allergies: ["allergie 1",],
    diets: ["diet 1", "diet 2"],);

@RoutePage()
class ProfileDetailsView extends HookWidget {
  final Profile profile;

  const ProfileDetailsView({Key? key, required this.profile}) : super (key: key);


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(profile.name,
              style: const TextStyle(color: Colors.black),
            ),
            SelectableText(profile.id,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black, size: 28),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PictureAttributeWidget(src : baseMediaUrl + profile.picture),
                  const SizedBox(width: 16,),
                  DescriptionAttributeWidget(text : profile.description),
                ],
              ),
              CustomGenericAttributeWidget(
                title: "Date of birth",
                child: Text(profile.dateOfBirth, style: const TextStyle(fontSize: 16),),
              ),
              PreferencesAttributeWidget(preferences: profile.preferences,),
            ],
          ),
      ),
    );
  }
}