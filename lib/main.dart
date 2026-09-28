import 'package:flutter/material.dart';

void main() {
  runApp(const ActividadEvaluableApp());
}

class ActividadEvaluableApp extends StatelessWidget {
  const ActividadEvaluableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Actividad evaluable - Ciclo de vida',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaActividad(),
    );
  }
}

class PantallaActividad extends StatefulWidget {
  const PantallaActividad({super.key});

  @override
  State<PantallaActividad> createState() => _PantallaActividadState();
}

class _PantallaActividadState extends State<PantallaActividad> {
  bool _mostrarSensor = true;
  int _version = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad: ciclo de vida de State')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Observe la consola mientras utiliza los botones',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (_mostrarSensor)
                SensorCicloVida(version: _version)
              else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('El SensorCicloVida fue retirado del árbol.'),
                  ),
                ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _mostrarSensor = !_mostrarSensor;
                      });
                    },
                    child: Text(
                      _mostrarSensor ? 'Quitar Sensor' : 'Insertar Sensor',
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _mostrarSensor
                        ? () {
                            setState(() {
                              _version++;
                            });
                          }
                        : null,
                    child: const Text('Actualizar desde el padre'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SensorCicloVida extends StatefulWidget {
  const SensorCicloVida({super.key, required this.version});

  final int version;

  @override
  // El print permite observar el primer método del ciclo de vida.
  // ignore: no_logic_in_create_state
  State<SensorCicloVida> createState() {
    // ignore: avoid_print
    print('1. createState()');
    return _SensorCicloVidaState();
  }
}

class _SensorCicloVidaState extends State<SensorCicloVida> {
  int _lecturas = 0;

  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    print('2. initState() - inicialización única');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ignore: avoid_print
    print('3. didChangeDependencies() - dependencias disponibles');
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('4. build() - reconstrucción de la interfaz');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SensorCicloVida - versión ${widget.version}',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Lecturas internas: $_lecturas'),
            Text('mounted: $mounted'),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () {
                setState(() {
                  _lecturas++;
                });
              },
              child: const Text('Ejecutar setState()'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant SensorCicloVida oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ignore: avoid_print
    print(
      '5. didUpdateWidget() - versión ${oldWidget.version} '
      '→ ${widget.version}',
    );
  }

  @override
  void deactivate() {
    // ignore: avoid_print
    print('6. deactivate() - retirado temporalmente del árbol');
    super.deactivate();
  }

  @override
  void dispose() {
    // ignore: avoid_print
    print('7. dispose() - destrucción definitiva, mounted será false');
    super.dispose();
  }
}
