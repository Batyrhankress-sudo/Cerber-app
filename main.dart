
import 'package:flutter/material.dart';

void main() => runApp(const CerberApp());

class CerberApp extends StatelessWidget {
  const CerberApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Цербер',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD63B32)),
      scaffoldBackgroundColor: const Color(0xFFF6F7F8),
      fontFamily: 'Roboto',
    ),
    home: const Home(),
  );
}

enum Risk { low, medium, high }

class AlertItem {
  final String title, type, location, time, description;
  final Risk risk;
  final String advice;
  const AlertItem(this.title, this.type, this.location, this.time, this.risk, this.description, this.advice);
}

const alerts = [
  AlertItem('Сильный ветер', 'Погода', 'Акмолинская область', '10 мин назад', Risk.medium,
      'Ожидаются порывы ветра. Возможны падение веток и ухудшение видимости.',
      'По возможности оставайтесь в помещении, избегайте деревьев и конструкций.'),
  AlertItem('Пожарная опасность', 'Пожар', 'Кокшетау и район', '32 мин назад', Risk.high,
      'Повышена вероятность быстрого распространения природных пожаров.',
      'Не разводите огонь на открытой местности. При обнаружении пожара звоните 112.'),
  AlertItem('Гололёд', 'Погода', 'Акмолинская область', '1 ч назад', Risk.low,
      'На отдельных участках дорог возможна гололедица.',
      'Передвигайтесь осторожно и увеличьте дистанцию на дороге.'),
];

Color riskColor(Risk r) => r == Risk.high
    ? const Color(0xFFD63B32)
    : r == Risk.medium ? const Color(0xFFE39A20) : const Color(0xFF4C8A5A);

String riskText(Risk r) => r == Risk.high ? 'Высокий' : r == Risk.medium ? 'Средний' : 'Низкий';

class Home extends StatefulWidget {
  const Home({super.key});
  @override State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      const Dashboard(),
      const AlertsPage(),
      const MapPage(),
      const GuidesPage(),
      const SettingsPage(),
    ];
    return Scaffold(
      body: SafeArea(child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.shield_outlined), selectedIcon: Icon(Icons.shield), label: 'Главная'),
          NavigationDestination(icon: Icon(Icons.notifications_none), selectedIcon: Icon(Icons.notifications), label: 'События'),
          NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Карта'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Инструкции'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  @override Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('ЦЕРБЕР', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2, fontSize: 14)),
      const SizedBox(height: 28),
      const Text('Безопасность рядом', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text('Информация об опасностях и действиях в чрезвычайных ситуациях.', style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF1E2328), borderRadius: BorderRadius.circular(24)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.shield, color: Colors.white, size: 34),
          SizedBox(height: 18),
          Text('Статус района', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 5),
          Text('Есть предупреждения', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Последнее обновление: 10 минут назад', style: TextStyle(color: Colors.white60)),
        ]),
      ),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _Quick(label: 'Оповещения', icon: Icons.notifications, color: const Color(0xFFD63B32))),
        const SizedBox(width: 12),
        Expanded(child: _Quick(label: 'Экстренная помощь', icon: Icons.phone, color: const Color(0xFF2F6BFF))),
      ]),
      const SizedBox(height: 24),
      const Text('Последние предупреждения', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w750)),
      const SizedBox(height: 10),
      ...alerts.take(2).map((a) => AlertCard(alert: a)),
    ],
  );
}

class _Quick extends StatelessWidget {
  final String label; final IconData icon; final Color color;
  const _Quick({required this.label, required this.icon, required this.color});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color), const SizedBox(height: 14),
      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ]),
  );
}

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});
  @override Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Оповещения', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text('Предупреждения поблизости', style: TextStyle(color: Colors.grey.shade700)),
      const SizedBox(height: 18),
      Wrap(spacing: 8, children: ['Все', 'Высокий', 'Средний', 'Низкий'].map((x) =>
        Chip(label: Text(x))).toList()),
      const SizedBox(height: 12),
      ...alerts.map((a) => AlertCard(alert: a)),
      const SizedBox(height: 12),
      const Text('Демонстрационные данные. Для реального использования требуется официальный источник оповещений.',
        style: TextStyle(color: Colors.grey, fontSize: 12)),
    ],
  );
}

class AlertCard extends StatelessWidget {
  final AlertItem alert;
  const AlertCard({super.key, required this.alert});
  @override Widget build(BuildContext context) => Card(
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AlertDetails(alert: alert))),
      child: Padding(padding: const EdgeInsets.all(17), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 10, height: 52, decoration: BoxDecoration(color: riskColor(alert.risk), borderRadius: BorderRadius.circular(8))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(alert.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w750)),
          const SizedBox(height: 5),
          Text('${alert.location} · ${alert.time}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          const SizedBox(height: 8),
          Text(riskText(alert.risk), style: TextStyle(color: riskColor(alert.risk), fontWeight: FontWeight.w700)),
        ])),
        const Icon(Icons.chevron_right),
      ])),
    ),
  );
}

class AlertDetails extends StatelessWidget {
  final AlertItem alert;
  const AlertDetails({super.key, required this.alert});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Предупреждение')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(
        color: riskColor(alert.risk).withOpacity(.12), borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Icon(Icons.warning_amber_rounded, color: riskColor(alert.risk), size: 34),
          const SizedBox(width: 12),
          Expanded(child: Text(riskText(alert.risk), style: TextStyle(color: riskColor(alert.risk), fontWeight: FontWeight.w800, fontSize: 18))),
        ])),
      const SizedBox(height: 24),
      Text(alert.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text('${alert.type} · ${alert.location}', style: TextStyle(color: Colors.grey.shade600)),
      const SizedBox(height: 8),
      Text('Обновлено ${alert.time}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      const SizedBox(height: 24),
      const Text('Что происходит', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text(alert.description, style: const TextStyle(height: 1.5)),
      const SizedBox(height: 22),
      const Text('Что делать', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text(alert.advice, style: const TextStyle(height: 1.5)),
      const SizedBox(height: 26),
      FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.share_outlined), label: const Text('Поделиться')),
    ]),
  );
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Карта угроз', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8),
    Text('Зоны риска рядом с вами', style: TextStyle(color: Colors.grey.shade700)),
    const SizedBox(height: 18),
    Container(height: 360, decoration: BoxDecoration(color: const Color(0xFFDDE4E7), borderRadius: BorderRadius.circular(24)),
      child: Stack(children: [
        const Center(child: Icon(Icons.map, size: 90, color: Color(0xFF9AA6AB))),
        Positioned(top: 55, left: 50, child: _Zone(color: const Color(0xFFD63B32), label: 'Высокий')),
        Positioned(bottom: 75, right: 50, child: _Zone(color: const Color(0xFFE39A20), label: 'Средний')),
        const Positioned(left: 20, bottom: 20, child: Text('Карта — прототип', style: TextStyle(color: Colors.black54))),
      ])),
    const SizedBox(height: 14),
    const Text('Реальные зоны появятся после подключения официального источника данных.', style: TextStyle(color: Colors.grey)),
  ]);
}

class _Zone extends StatelessWidget {
  final Color color; final String label;
  const _Zone({required this.color, required this.label});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
  );
}

class GuidesPage extends StatelessWidget {
  const GuidesPage({super.key});
  final items = const [
    ['Пожар', 'Покиньте опасную зону и сообщите по 112.', Icons.local_fire_department],
    ['Землетрясение', 'Оставайтесь внутри, защитите голову и ждите окончания толчков.', Icons.home_work],
    ['Наводнение', 'Перейдите на возвышенность и следуйте указаниям служб.', Icons.water],
    ['Сильный ветер', 'Оставайтесь в помещении и держитесь подальше от окон.', Icons.air],
  ];
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Инструкции', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8),
    Text('Короткие действия в чрезвычайной ситуации', style: TextStyle(color: Colors.grey.shade700)),
    const SizedBox(height: 18),
    ...items.map((x) => Card(elevation: 0, child: ListTile(
      leading: Icon(x[2] as IconData, color: const Color(0xFFD63B32)),
      title: Text(x[0] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(x[1] as String),
      trailing: const Icon(Icons.chevron_right),
    ))),
  ]);
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override State<SettingsPage> createState() => _SettingsState();
}
class _SettingsState extends State<SettingsPage> {
  bool alertsOn = true, locationOn = true;
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Настройки', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
    const SizedBox(height: 18),
    Card(elevation: 0, child: Column(children: [
      SwitchListTile(title: const Text('Оповещения'), subtitle: const Text('Получать предупреждения'), value: alertsOn, onChanged: (v) => setState(() => alertsOn = v)),
      SwitchListTile(title: const Text('Геолокация'), subtitle: const Text('Показывать угрозы рядом'), value: locationOn, onChanged: (v) => setState(() => locationOn = v)),
    ])),
    const SizedBox(height: 16),
    const ListTile(leading: Icon(Icons.info_outline), title: Text('О приложении'), subtitle: Text('Цербер · версия 1.3')),
  ]);
}
