import 'package:alchemist/alchemist.dart';
import 'package:surreal_auth/widget/screens/home/widget/widget/counter.dart';

void main() {
  goldenTest(
    'Counter golden',
    fileName: 'counter',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'default',
          child: const Counter(counter: 0),
        ),
        GoldenTestScenario.withTextScaleFactor(
          textScaleFactor: 2,
          name: '2x_scale',
          child: const Counter(counter: 0),
        ),
        GoldenTestScenario.withTextScaleFactor(
          textScaleFactor: 3,
          name: '3x_scale',
          child: const Counter(counter: 0),
        ),
        GoldenTestScenario.withTextScaleFactor(
          textScaleFactor: 3,
          name: 'big default',
          child: const Counter(counter: 1234567890),
        ),
        GoldenTestScenario.withTextScaleFactor(
          textScaleFactor: 2,
          name: 'big 2x_scale',
          child: const Counter(counter: 1234567890),
        ),
        GoldenTestScenario.withTextScaleFactor(
          textScaleFactor: 3,
          name: 'big 3x_scale',
          child: const Counter(counter: 1234567890),
        ),
      ],
    ),
  );
}
