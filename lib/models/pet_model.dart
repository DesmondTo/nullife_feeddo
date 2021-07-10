// import 'package:flutter/material.dart';

enum Behaviour {
  Balance,
  Meh,
  Unbalance,
}

class Pet {
  final int id;
  final String petName;
  final List<String> petImagesName;
  final Behaviour behaviour;

  Pet(
      {required this.id,
      required this.petName,
      required this.petImagesName,
      required this.behaviour});

  static Pet createPetbyID(int id) {
    return id == 0
        ? Pet(
            id: 0,
            petName: 'Woody',
            petImagesName: <String>[
              "assets/images/sample_woody_display.png",
            ],
            behaviour: Behaviour.Balance)
        : id == 1
            ? Pet(
                id: 1,
                petName: 'Splashy',
                petImagesName: <String>[
                  "assets/images/sample_splashy_display.png",
                ],
                behaviour: Behaviour.Balance)
            : Pet(
                id: 2,
                petName: 'Sol',
                petImagesName: <String>[
                  "assets/images/sample_sol_display.png",
                ],
                behaviour: Behaviour.Balance);
  }

  static List<Pet> generatePetList() {
    return [
      Pet(
          id: 0,
          petName: 'Woody',
          petImagesName: <String>[
            "assets/images/sample_woody_display.png",
          ],
          behaviour: Behaviour.Balance),
      Pet(
          id: 1,
          petName: 'Splashy',
          petImagesName: <String>[
            "assets/images/sample_splashy_display.png",
          ],
          behaviour: Behaviour.Balance),
      Pet(
          id: 2,
          petName: 'Sol',
          petImagesName: <String>[
            "assets/images/sample_sol_display.png",
          ],
          behaviour: Behaviour.Balance),
    ];
  }
}
