import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Добавляем Riverpod
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart'; // для deficienciesBoxName (пока нужен для ValueListenableBuilder)
import '../models/checklist_instance.dart';
import '../models/deficiency.dart';
import '../models/enums.dart';
import '../generated/l10n.dart';
import 'package:intl/intl.dart';
import '../repositories/deficiency_repository.dart'; // Подключаем репозиторий
import '../screens/deficiency_detail_screen.dart';

// Меняем StatefulWidget на ConsumerStatefulWidget
class DeficiencyListScreen extends ConsumerStatefulWidget {
  const DeficiencyListScreen({super.key});

  @override
  ConsumerState<DeficiencyListScreen> createState() => _DeficiencyListScreenState();
}

class _DeficiencyListScreenState extends ConsumerState<DeficiencyListScreen> {
  // Фильтр оставляем в UI, так как это состояние экрана
  DeficiencyStatus? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    // В идеале позже мы заменим и ValueListenableBuilder на Riverpod stream/provider,
    // но пока оставим прослушивание коробки для реактивного обновления списка
    final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);
    final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).deficiencyList),
        actions: [
          _buildFilterDropdown(),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: deficienciesBox.listenable(),
        builder: (context, Box<Deficiency> box, _) {
          return ValueListenableBuilder(
            valueListenable: instancesBox.listenable(),
            builder: (context, Box<ChecklistInstance> instBox, _) {
              final repository = ref.read(deficiencyRepositoryProvider);
              var deficiencies = repository.getAll();

              if (_selectedFilter != null) {
                deficiencies = deficiencies
                    .where((d) => d.status == _selectedFilter)
                    .toList();
              }

              if (deficiencies.isEmpty) {
                return Center(child: Text(S.of(context).noDeficienciesRegistered));
              }

              // Grouping logic
              final Map<dynamic, List<Deficiency>> instanceGroups = {};
              final Map<String, List<Deficiency>> manualGroups = {};

              for (var def in deficiencies) {
                if (def.instanceId != null) {
                  instanceGroups.putIfAbsent(def.instanceId, () => []).add(def);
                } else {
                  final shipGroupKey = def.shipName?.isNotEmpty == true ? def.shipName! : S.of(context).unnamedCheck;
                  manualGroups.putIfAbsent(shipGroupKey, () => []).add(def);
                }
              }

              final instanceEntries = instanceGroups.entries.toList();
              final manualEntries = manualGroups.entries.toList();

              return ListView(
                children: [
                  ...instanceEntries.map((entry) {
                    final instance = instBox.get(entry.key);
                    return _buildGroupCard(instance, entry.value);
                  }),
                  ...manualEntries.map((entry) {
                    return _buildManualGroupCard(entry.key, entry.value);
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<DeficiencyStatus?>(
        value: _selectedFilter,
        icon: const Icon(Icons.filter_list, color: Colors.white),
        dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
        style: const TextStyle(color: Colors.white),
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(S.of(context).filterAll, style: const TextStyle(color: Colors.black)),
          ),
          ...DeficiencyStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.name, style: const TextStyle(color: Colors.black)), 
            );
          }),
        ],
        onChanged: (value) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildGroupCard(ChecklistInstance? instance, List<Deficiency> defs) {
    if (instance == null) return const SizedBox.shrink(); // Hide if parent was wiped and no cascade occurred (shouldn't happen with GC)

    final String shipName = instance.shipName?.isNotEmpty == true ? instance.shipName! : S.of(context).unnamedCheck;
    final String dateStr = DateFormat.yMd(Localizations.localeOf(context).languageCode).format(instance.date);
    final openCount = defs.where((d) => d.status != DeficiencyStatus.closed).length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: ExpansionTile(
        leading: const Icon(Icons.directions_boat_outlined),
        title: Text(shipName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).startedOn(dateStr)),
            if (instance.port?.isNotEmpty == true) Text(S.of(context).port(instance.port!), style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (instance.captainNameOnCheck?.isNotEmpty == true) Text(S.of(context).captain(instance.captainNameOnCheck!), style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: _buildCountBadge(openCount, defs.length),
        children: defs.map((d) => _buildDeficiencyCard(d)).toList(),
      ),
    );
  }

  Widget _buildManualGroupCard(String shipName, List<Deficiency> defs) {
    final openCount = defs.where((d) => d.status != DeficiencyStatus.closed).length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: ExpansionTile(
        leading: const Icon(Icons.build_circle_outlined),
        title: Text(shipName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(S.of(context).deficiencyList, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: _buildCountBadge(openCount, defs.length),
        children: defs.map((d) => _buildDeficiencyCard(d)).toList(),
      ),
    );
  }

  Widget _buildCountBadge(int openCount, int totalCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: openCount > 0 ? Colors.redAccent.withAlpha(200) : Colors.green.withAlpha(200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$openCount / $totalCount',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDeficiencyCard(Deficiency deficiency) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.withAlpha(50), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(deficiency.description),
          subtitle: Text('Status: ${deficiency.status.name}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(deficiency),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeficiencyDetailScreen(deficiencyKey: deficiency.key),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Deficiency deficiency) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteDeficiency),
        content: Text(S.of(context).deleteDeficiencyConfirmation(deficiency.description)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );

    if (confirmed == true && deficiency.key != null) {
      // ВОТ ОНА — ЧИСТАЯ АРХИТЕКТУРА!
      // Экран просто отдает команду, а Репозиторий сам удаляет и данные, и фотографии.
      await ref.read(deficiencyRepositoryProvider).delete(deficiency.key);
    }
  }
}