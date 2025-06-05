// biolab_home.dart
import 'package:flutter/material.dart';

class BioLabHomePage extends StatefulWidget {
  const BioLabHomePage({super.key});

  @override
  State<BioLabHomePage> createState() => _BioLabHomePageState();
}

class _BioLabHomePageState extends State<BioLabHomePage> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = mockarDados();
  }

  Map<String, dynamic> mockarDados() {
    return {
      'temperatura': 24.5,
      'umidade': 65,
      'sensoresAtivos': 5,
      'ch4': {'valor': 450, 'percent': 25},
      'co2': {'valor': 850, 'percent': 65},
      'glp': {'valor': 120, 'percent': 15},
      'chama': {'detectado': false},
      'hora': TimeOfDay.now().format(context)
    };
  }

  Widget statusCard(String title, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
      ],
    );
  }

  Widget sensorCard(String nome, String sensor, int valor, int percent, Color cor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf8fafc),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(nome, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          Text(sensor, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(cor),
                  strokeWidth: 8,
                ),
              ),
              Text("$percent%", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
            ],
          ),
          const SizedBox(height: 10),
          Text("$valor ppm", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget chamaCard(bool detectada) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf8fafc),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text("Detecção de Chama", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const Text("Sensor KY-026", style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 20),
          Icon(
            detectada ? Icons.warning_amber_rounded : Icons.check_circle_outline,
            color: detectada ? Colors.red : Colors.blue,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            detectada ? "Detectada" : "Não Detectada",
            style: TextStyle(
              color: detectada ? Colors.red : Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            detectada ? "Status: Perigo" : "Status: Seguro",
            style: TextStyle(color: detectada ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final co2Percent = data['co2']['percent'] as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BioLab Monitor'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 6),
                Text("Conectado", style: TextStyle(fontSize: 12))
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFf8fafc),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statusCard("Temperatura", "${data['temperatura']}ºC", Colors.black),
                  statusCard("Umidade", "${data['umidade']}%", Colors.black),
                  statusCard("Sensores Ativos", "${data['sensoresAtivos']}/5", Colors.black),
                  statusCard("Status", co2Percent >= 60 ? "Atenção" : "Normal", co2Percent >= 60 ? Colors.orange : Colors.green),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text("Última atualização: ${data['hora']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                sensorCard("Metano (CH₄)", "Sensor MG4", data['ch4']['valor'], data['ch4']['percent'], Colors.green),
                sensorCard("Dióxido de Carbono (CO₂)", "Sensor MG135", data['co2']['valor'], data['co2']['percent'], Colors.orange),
                sensorCard("Gás Liquefeito de Petróleo (GLP)", "Sensor MQ2", data['glp']['valor'], data['glp']['percent'], Colors.green),
                chamaCard(data['chama']['detectado']),
              ],
            )
          ],
        ),
      ),
    );
  }
}
