import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/characters/ghost.dart';
import 'package:pacman/characters/player.dart';
import 'package:pacman/components/alert_dialog.dart';
import 'package:pacman/components/pathway.dart';
import 'package:pacman/components/pixel.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer timerPlayer;
  late Timer timerGhost;

  int player = kNumberInRow * 15 + 1;
  int ghost = kNumberInRow * 1 + 9;
  int score = 0;
  bool mouthClosed = false;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    156,
    129,
    140,
    151,
    162,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149,
    158,
    160
  ];

  List<int> food = [];

  String direction = "right";
  String ghostDirection = "left";

  void getFood() {
    for (int i = 0; i < kNumberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void restart() {
    score = 0;
    player = kNumberInRow * 15 + 1;
    ghost = kNumberInRow * 1 + 9;
    food = [];
    direction = "right";
    ghostDirection = "left";
    timerGhost.cancel();
    Navigator.pop(context);
  }

  Duration playerDuration = const Duration(milliseconds: 120);
  Duration ghostDuration = const Duration(milliseconds: 200);

  void startGame() {
    getFood();
    moveGhost();
    if (player != kNumberInRow * 15 + 1) {
      player = kNumberInRow * 15 + 1;
    }

    timerPlayer = Timer.periodic(playerDuration, (timer) {
      setState(() {
        mouthClosed = !mouthClosed;
      });
      if (food.contains(player)) {
        food.remove(player);
        score++;
      }

      if (player == ghost) {
        setState(() {
          player = -1;
        });
        timer.cancel();

        showDialog(
            context: context,
            builder: (context) => MyAlertDialog(
                  score: score,
                  onPressed: restart,
                ));
      }

      switch (direction) {
        case "right":
          moveRight();
          break;

        case "left":
          moveLeft();
          break;

        case "up":
          moveUp();
          break;

        case "down":
          moveDown();
          break;
      }
    });
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveUp() {
    if (!barriers.contains(player - kNumberInRow)) {
      setState(() {
        player -= kNumberInRow;
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + kNumberInRow)) {
      setState(() {
        player += kNumberInRow;
      });
    }
  }

  void moveGhost() {
    timerGhost = Timer.periodic(ghostDuration, (timer) {
      if (ghost == kNumberInRow * 4 + 5 && ghostDirection == "right" ||
          ghost == kNumberInRow * 4 + 5 && ghostDirection == "left") {
        ghostDirection = "down";
      } else if (ghost == kNumberInRow * 8 + 5 && ghostDirection == "down") {
        ghostDirection = "down";
      } else if (ghost == kNumberInRow * 15 + 7) {
        ghostDirection = "right";
      } else if (ghostDirection == "left" && ghost == kNumberInRow * 12 + 5 ||
          ghostDirection == "up" && ghost == kNumberInRow * 8 + 5) {
        ghostDirection = "up";
      } else {
        if (!barriers.contains(ghost - 1) && ghostDirection != "right") {
          ghostDirection = "left";
        } else if (!barriers.contains(ghost + 1) && ghostDirection != "left") {
          ghostDirection = "right";
        } else if (!barriers.contains(ghost + kNumberInRow) &&
            ghostDirection != "up") {
          ghostDirection = "down";
        } else if (!barriers.contains(ghost - kNumberInRow) &&
            ghostDirection != "down") {
          ghostDirection = "up";
        }
      }

      switch (ghostDirection) {
        case "left":
          setState(() {
            ghost--;
          });
          break;

        case "right":
          setState(() {
            ghost++;
          });
          break;

        case "up":
          setState(() {
            ghost -= kNumberInRow;
          });
          break;

        case "down":
          setState(() {
            ghost += kNumberInRow;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: GridView.builder(
                  itemCount: kNumberOfSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kNumberInRow),
                  itemBuilder: (context, int index) {
                    if (ghost == index) {
                      return const Ghost();
                    } else if (player == index) {
                      if (mouthClosed) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.yellow, shape: BoxShape.circle),
                          ),
                        );
                      } else {
                        switch (direction) {
                          case "right":
                            return const Player();

                          case "left":
                            return Transform.rotate(
                              angle: pi,
                              child: const Player(),
                            );

                          case "up":
                            return Transform.rotate(
                              angle: 3 * pi / 2,
                              child: const Player(),
                            );

                          case "down":
                            return Transform.rotate(
                              angle: pi / 2,
                              child: const Player(),
                            );

                          default:
                            return const Player();
                        }
                      }
                    } else if (barriers.contains(index)) {
                      return Pixel(
                          index: index,
                          innerColour: Colors.blue[800],
                          outerColor: Colors.blue[900]);
                    } else if (food.contains(index)) {
                      return Pathway(
                        index: index,
                        outerColor: Colors.black,
                        innerColour: Colors.yellow,
                      );
                    } else {
                      return Pixel();
                    }
                  }),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Score: $score',
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
              GestureDetector(
                onTap: startGame,
                child: const Text('P L A Y',
                    style: TextStyle(color: Colors.white, fontSize: 40)),
              )
            ],
          ))
        ],
      ),
    );
  }
}
