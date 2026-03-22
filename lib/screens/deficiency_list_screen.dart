import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Добавляем Riverpod
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart'; // для deficienciesBoxName (пока нужен для ValueListenableBuilder)
import '../models/deficiency.dart';
import '../models/enums.dart';
import '../generated/l10n.dart';
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
          // Читаем данные через репозиторий, а не напрямую из box
          final repository = ref.read(deficiencyRepositoryProvider);
          var deficiencies = repository.getAll();

          // Применяем фильтр
          if (_selectedFilter != null) {
            deficiencies = deficiencies
                .where((d) => d.status == _selectedFilter)
                .toList();
          }

          if (deficiencies.isEmpty) {
            return Center(child: Text(S.of(context).noDeficienciesRegistered));
          }

          return ListView.builder(
            itemCount: deficiencies.length,
            itemBuilder: (context, index) {
              final deficiency = deficiencies[index];
              return _buildDeficiencyCard(deficiency);
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

  Widget _buildDeficiencyCard(Deficiency deficiency) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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