import 'package:dzikr_tasbih/data/dummy/dzikir_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tasbih_provider.dart';

void showDzikirSelectionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Consumer<TasbihProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            // PERBAIKAN 1: Penggunaan constraints untuk maxHeight
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Dzikir',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {
                        Navigator.pop(context);
                        // Mengakses fungsi dialog tambah dzikir yang sudah dibuat
                        _showAddDzikirDialog(context, provider);
                      },
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: dzikirList.length,
                    itemBuilder: (context, index) {
                      final item = dzikirList[index];
                      final isSelected = index == provider.selectedDzikirIndex;

                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: Colors.green.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text('Target: ${item.target}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ICON EDIT
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditDzikirDialog(
                                  context,
                                  provider,
                                  index,
                                  item.title,
                                  item.target,
                                );
                              },
                            ),
                            // ICON HAPUS (SAMPAH)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmDialog(
                                  context,
                                  provider,
                                  index,
                                  item.title,
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          provider.changeDzikir(index);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// PERBAIKAN 2: Penambahan fungsi dialog untuk Tambah Dzikir
void _showAddDzikirDialog(BuildContext context, TasbihProvider provider) {
  final titleController = TextEditingController();
  final targetController = TextEditingController(text: "33");

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Tambah Dzikir Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Nama Dzikir'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Hitungan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final target = int.tryParse(targetController.text) ?? 33;

              if (title.isNotEmpty) {
                provider.addDzikir(title, target);
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      );
    },
  );
}

/// Dialog Edit Dzikir
void _showEditDzikirDialog(
  BuildContext context,
  TasbihProvider provider,
  int index,
  String currentTitle,
  int currentTarget,
) {
  final titleController = TextEditingController(text: currentTitle);
  final targetController =
      TextEditingController(text: currentTarget.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Dzikir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Nama Dzikir'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Hitungan'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleController.text.trim();
              final newTarget =
                  int.tryParse(targetController.text) ?? currentTarget;

              if (newTitle.isNotEmpty) {
                provider.editDzikir(index, newTitle, newTarget);
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    },
  );
}

/// Dialog Konfirmasi Hapus
void _showDeleteConfirmDialog(
  BuildContext context,
  TasbihProvider provider,
  int index,
  String title,
) {
  if (dzikirList.length <= 1) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Minimal harus ada 1 dzikir dalam daftar.')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Hapus Dzikir'),
        content: Text('Apakah Anda yakin ingin menghapus "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteDzikir(index);
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
