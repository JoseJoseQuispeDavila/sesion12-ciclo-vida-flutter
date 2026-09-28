import 'package:flutter_test/flutter_test.dart';
import 'package:sesion12_ciclo_vida/main.dart';

void main() {
  testWidgets('recorre las transiciones principales del ciclo de vida', (
    tester,
  ) async {
    await tester.pumpWidget(const ActividadEvaluableApp());
    expect(find.text('Lecturas internas: 0'), findsOneWidget);

    await tester.tap(find.text('Ejecutar setState()'));
    await tester.pump();
    expect(find.text('Lecturas internas: 1'), findsOneWidget);

    await tester.tap(find.text('Actualizar desde el padre'));
    await tester.pump();
    expect(find.text('SensorCicloVida - versión 2'), findsOneWidget);
    expect(find.text('Lecturas internas: 1'), findsOneWidget);

    await tester.tap(find.text('Quitar Sensor'));
    await tester.pump();
    expect(find.byType(SensorCicloVida), findsNothing);

    await tester.tap(find.text('Insertar Sensor'));
    await tester.pump();
    expect(find.byType(SensorCicloVida), findsOneWidget);
    expect(find.text('Lecturas internas: 0'), findsOneWidget);
  });
}
