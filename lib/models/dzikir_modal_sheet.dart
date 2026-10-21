import 'package:flutter/material.dart';

// SESUAIKAN DENGAN LOKASI FILE KAMU
import '../models/dzikir_model.dart';
import '../providers/tasbih_provider.dart';

class DzikirModalSheet extends StatefulWidget {
  final TasbihProvider provider;
  final dynamic theme;

  const DzikirModalSheet({
    super.key,
    required this.provider,
    required this.theme,
  });

  @override
  State<DzikirModalSheet> createState() => _DzikirModalSheetState();
}

class _DzikirModalSheetState extends State<DzikirModalSheet> {
  final newTitleController = TextEditingController();
  final newTargetController = TextEditingController();

  @override
  void dispose() {
    newTitleController.dispose();
    newTargetController.dispose();
    super.dispose();
  }

  void _showEditDialog(int index, DzikirModel dzikir) {
    final editTitleController = TextEditingController(text: dzikir.title);
    final editTargetController =
        TextEditingController(text: dzikir.target.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Dzikir",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editTitleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Nama Dzikir",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: editTargetController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Target Hitungan",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("Batal", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.theme.accentColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final newTitle = editTitleController.text.trim();
                final newTarget = int.tryParse(editTargetController.text);

                if (newTitle.isNotEmpty && newTarget != null && newTarget > 0) {
                  widget.provider.editDzikir(index, newTitle, newTarget);
                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memanggil dzikirList dari provider
    final List<DzikirModel> listDzikir = widget.provider.dzikirList;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white24,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pilih Dzikir",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Text(
                //   "Geser ➔ Edit | Hapus ⬅",
                //   style: TextStyle(fontSize: 11, color: Colors.white38),
                // ),
              ],
            ),
            const SizedBox(height: 17),

            /// DZIKIR LIST
            ...List.generate(
              listDzikir.length,
              (index) {
                final dzikir = listDzikir[index];
                final isSelected = widget.provider.selectedDzikirIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: ValueKey("${dzikir.title}_$index"),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _showEditDialog(index, dzikir);
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        if (listDzikir.length <= 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Minimal harus ada 1 dzikir!"),
                            ),
                          );
                          return false;
                        }

                        return await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF1E293B),
                                title: const Text("Hapus Dzikir?",
                                    style: TextStyle(color: Colors.white)),
                                content: Text(
                                  "Apakah kamu yakin ingin menghapus '${dzikir.title}'?",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Batal",
                                        style:
                                            TextStyle(color: Colors.white54)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Hapus",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ) ??
                            false;
                      }
                      return false;
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        widget.provider.deleteDzikir(index);
                      }
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Edit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Hapus",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.delete, color: Colors.white),
                        ],
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        widget.provider.changeDzikir(index);
                        Navigator.pop(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isSelected
                              ? widget.theme.accentColor.withOpacity(0.15)
                              : Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: isSelected
                                ? widget.theme.accentColor
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: widget.theme.accentColor,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                dzikir.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "${dzikir.target}",
                              style: TextStyle(
                                color: widget.theme.accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const Divider(color: Colors.white12, height: 32),

            /// TAMBAH DZIKIR BARU
            const Text(
              "Tambah Dzikir Baru",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 17),
            TextField(
              controller: newTitleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Nama Dzikir",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newTargetController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Target Hitungan",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final title = newTitleController.text.trim();
                  final target = int.tryParse(newTargetController.text);
                  if (title.isNotEmpty && target != null && target > 0) {
                    widget.provider.addDzikir(title, target);
                    newTitleController.clear();
                    newTargetController.clear();
                    Navigator.pop(context);
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.theme.accentColor,
                  side: BorderSide(color: widget.theme.accentColor),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text("Tambah Dzikir"),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
          ],
        ),
      ),
    );
  }
}
