import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedVerticalText extends HookWidget {
  const AnimatedVerticalText({
    required this.currentText,
    required this.targetText,
    required this.animationController,
    super.key,
  });
  final AnimationController animationController;
  final String currentText;
  final String targetText;
  @override
  Widget build(BuildContext context) {
    var animation = useAnimation(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    var totalRotations = useMemoized(
      () => _getAmountOfLetterRotations(currentText, targetText),
      [currentText, targetText],
    );
    var progression = (animation * totalRotations).round();
    var currentRotation = progression - (progression % 25) + 25;
    var displayedText = currentRotation == 0
        ? currentText.split('')
        : _getLetters(
            currentText,
            targetText,
            min(currentRotation, progression),
          );
    return RotatedBox(
      quarterTurns: 1,
      child: Row(
        children: [
          // print each letter individually
          for (var letter in displayedText) ...[
            Text(
              letter,
              style: const TextStyle(
                fontSize: 100.0,
                color: Colors.grey,
                letterSpacing: 20,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _getLetters(String from, String target, int rotations) {
    var targetText = <String>[];
    var usedRotations = 0;
    // loop through each letter in the target text and use up the rotations
    // once rotations are used up, fill the rest of the letters with from
    for (var i = 0; i < target.length; i++) {
      if (i >= from.length) {
        targetText.add(String.fromCharCode(65 + rotations - usedRotations));
        usedRotations += rotations - usedRotations;
      } else {
        var currentLetter = from.codeUnitAt(i);
        var targetLetter = target.codeUnitAt(i);
        if (currentLetter == targetLetter) {
          targetText.add(String.fromCharCode(currentLetter));
        } else if (currentLetter < targetLetter) {
          var letter = currentLetter + rotations - usedRotations;
          if (letter > targetLetter) {
            letter = targetLetter;
          }
          targetText.add(String.fromCharCode(letter));
          usedRotations += letter - currentLetter;
        } else {
          var letter = currentLetter - rotations + usedRotations;
          if (letter < targetLetter) {
            letter = targetLetter;
          }
          targetText.add(String.fromCharCode(letter));
          usedRotations += currentLetter - letter;
        }
      }
    }
    return targetText;
  }

  int _getAmountOfLetterRotations(String from, String to) {
    // return the amount of times each letter has to rotate to create to
    var sum = 0;
    for (var i = 0; i < to.length; i++) {
      if (i >= from.length) {
        sum += to.codeUnitAt(i) - 65;
      } else {
        sum += (to.codeUnitAt(i) - from.codeUnitAt(i)).abs();
      }
    }
    return sum;
  }
}
