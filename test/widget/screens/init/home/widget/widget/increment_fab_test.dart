import 'package:alchemist/alchemist.dart';
import 'package:surreal_auth/widget/screens/home/widget/widget/increment_fab.dart';

void main() {
  goldenTest(
    'Increment FAB golden',
    fileName: 'increment_fab',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'default',
          child: IncrementFab(
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}
