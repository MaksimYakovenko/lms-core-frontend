import 'package:flutter/material.dart';
import '../journal_details_service.dart';
import '../utils/grade_style.dart';


class StudentGradeRow extends StatefulWidget {
  const StudentGradeRow({
    super.key,
    required this.index,
    required this.student,
    required this.lessons,
    required this.colWidth,
    required this.nameColWidth,
    required this.indexColWidth,
    required this.rowHeight,
  });

  final int index;
  final JournalStudent student;
  final List<JournalLesson> lessons;
  final double colWidth;
  final double nameColWidth;
  final double indexColWidth;
  final double rowHeight;

  @override
  State<StudentGradeRow> createState() => _StudentGradeRowState();
}

class _StudentGradeRowState extends State<StudentGradeRow> {
  bool _hovered = false;

  static const _hoverBg = Color(0xFFEFF6FF);
  static const _hoverBorder = Color(0xFFBFDBFE);

  Color get _rowBg {
    if (_hovered) return _hoverBg;
    return widget.index.isOdd ? Colors.white : const Color(0xFFF9FAFB);
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final lessons = widget.lessons;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: widget.rowHeight,
        decoration: BoxDecoration(
          color: _rowBg,
          border: Border(
            bottom: BorderSide(
              color: _hovered ? _hoverBorder : const Color(0xFFE5E7EB),
            ),
          ),
        ),
        child: Row(
          children: [
            _RowCell(
              width: widget.indexColWidth,
              background: _rowBg,
              borderColor: _borderColor,
              child: Center(
                child: Text(
                  '${widget.index}',
                  style: TextStyle(
                    fontSize: 14,
                    color: _hovered
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            _RowCell(
              width: widget.nameColWidth,
              background: _rowBg,
              borderColor: _borderColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  student.fullName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _hovered
                        ? const Color(0xFF1D4ED8)
                        : const Color(0xFF111827),
                  ),
                ),
              ),
            ),
            ...lessons.asMap().entries.map(
                  (e) {
                final raw = student.gradeFor(e.value.id);

                return _RowCell(
                  width: widget.colWidth,
                  background: _rowBg,
                  borderColor: _borderColor,
                  isLast: e.key == lessons.length - 1,
                  child: Center(
                    child: raw == null || raw.isEmpty
                        ? Text(
                      '—',
                      style: TextStyle(
                        fontSize: 13,
                        color: _hovered
                            ? const Color(0xFF93C5FD)
                            : const Color(0xFFD1D5DB),
                      ),
                    )
                        : _GradeBadge(raw: raw),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color get _borderColor {
    return _hovered ? _hoverBorder : const Color(0xFFE5E7EB);
  }
}

class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.raw});

  final String raw;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 36,
        maxWidth: 52,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: GradeStyle.background(raw),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          raw.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: GradeStyle.text(raw),
          ),
        ),
      ),
    );
  }
}

class _RowCell extends StatelessWidget {
  const _RowCell({
    required this.width,
    required this.child,
    required this.background,
    required this.borderColor,
    this.isLast = false,
  });

  final double width;
  final Widget child;
  final Color background;
  final Color borderColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: isLast
          ? BoxDecoration(color: background)
          : BoxDecoration(
        color: background,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: child,
    );
  }
}