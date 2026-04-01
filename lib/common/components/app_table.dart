import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lms_core_frontend/common/components/app_button.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

// ── Токени ───────────────────────────────────────────────────────────────────

const _kBorderColor = Color(0xFFE2E8F0);
const _kGray50 = Color(0xFFF9FAFB);
const _kGray600 = Color(0xFF4B5563);

// ── Моделі ───────────────────────────────────────────────────────────────────

/// Опис однієї колонки таблиці
class AppTableColumn {
  final String label;
  final FlexColumnWidth width;
  final bool center;
  final bool right;

  const AppTableColumn({
    required this.label,
    this.width = const FlexColumnWidth(1.0),
    this.center = false,
    this.right = false,
  });
}

class AppTable extends StatelessWidget {
  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.totalCount,
    required this.currentPage,
    this.itemsPerPage = 8,
    required this.onPageChange,
    this.isLoading = false,
    this.emptyText = 'No data available',
  });

  final List<AppTableColumn> columns;
  final List<List<Widget>> rows;
  final int totalCount;
  final int currentPage;
  final int itemsPerPage;
  final ValueChanged<int> onPageChange;
  final bool isLoading;
  final String emptyText;

  int get _totalPages => (totalCount / itemsPerPage).ceil().clamp(1, 9999);
  int get _start => (currentPage - 1) * itemsPerPage + 1;
  int get _end => (_start + rows.length - 1).clamp(1, totalCount);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: _kBorderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: isLoading
              ? const _LoadingBody()
              : rows.isEmpty
                  ? _EmptyBody(text: emptyText)
                  : Table(
                      columnWidths: {
                        for (var i = 0; i < columns.length; i++)
                          i: columns[i].width,
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(color: _kBorderColor),
                      ),
                      children: [
                        // Header
                        TableRow(
                          decoration: const BoxDecoration(color: _kGray50),
                          children: columns
                              .map((c) => _THead(
                                    c.label,
                                    center: c.center,
                                    right: c.right,
                                  ))
                              .toList(),
                        ),
                        // Rows
                        ...rows.map(
                          (cells) => TableRow(
                            children: List.generate(
                              cells.length,
                              (i) => TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: _TCell(
                                  center: columns[i].center,
                                  right: columns[i].right,
                                  child: cells[i],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              totalCount == 0
                  ? 'Немає записів'
                  : 'Показано $_start–$_end з $totalCount записів',
              style: const TextStyle(fontSize: 14, color: _kGray600),
            ),
            Row(
              children: [
                AppButton(
                  variant: ButtonVariant.outline,
                  size: ButtonSize.defaultSize,
                  disabled: currentPage == 1,
                  onPressed: () => onPageChange(currentPage - 1),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.chevronLeft, size: 16),
                      SizedBox(width: 4),
                      Text('Минула'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AppButton(
                  variant: ButtonVariant.outline,
                  size: ButtonSize.defaultSize,
                  disabled: currentPage == _totalPages,
                  onPressed: () => onPageChange(currentPage + 1),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Наступна'),
                      SizedBox(width: 4),
                      Icon(LucideIcons.chevronRight, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ── TableHead ─────────────────────────────────────────────────────────────────

class _THead extends StatelessWidget {
  const _THead(this.label, {this.center = false, this.right = false});

  final String label;
  final bool center;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        label,
        textAlign: right
            ? TextAlign.right
            : (center ? TextAlign.center : TextAlign.left),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}

// ── TableCell ─────────────────────────────────────────────────────────────────

class _TCell extends StatelessWidget {
  const _TCell({required this.child, this.center = false, this.right = false});

  final Widget child;
  final bool center;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Align(
        alignment: right
            ? Alignment.centerRight
            : (center ? Alignment.center : Alignment.centerLeft),
        child: child,
      ),
    );
  }
}

// ── Loading / Empty ───────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, color: _kGray600),
        ),
      ),
    );
  }
}

