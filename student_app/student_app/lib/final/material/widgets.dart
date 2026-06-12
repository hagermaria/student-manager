import 'package:flutter/material.dart';
import 'package:student_app/final/theme.dart';

// ─── Buttons ───────────────────────────────────────────────────────────────

Widget primaryButton({
  required String text,
  required VoidCallback onTap,
  double? width,
  bool isDestructive = false,
}) =>
    SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDestructive ? AppTheme.danger : AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        ),
      ),
    );

Widget chipButton({
  required String text,
  required VoidCallback onTap,
  bool selected = false,
}) =>
    GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surface,
          border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.divider,
              width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textSecondary,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );

Widget departmentTile({
  required String text,
  required VoidCallback onTap,
  required IconData icon,
}) =>
    Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(icon, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );

// ─── Text ──────────────────────────────────────────────────────────────────

Widget text1({required String text}) => Text(
      text,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

Widget text2({required String text}) => Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );

// ─── Section Header ────────────────────────────────────────────────────────

Widget sectionHeader(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );

// ─── Info Row ─────────────────────────────────────────────────────────────

Widget infoRow({required String label, required String value}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

// ─── Convert ───────────────────────────────────────────────────────────────

int toInt(String num) {
  if (num == 'First') return 1;
  if (num == 'Second') return 2;
  if (num == 'Third') return 3;
  if (num == 'Fourth') return 4;
  return 0;
}

String toStr(int num) {
  if (num == 1) return 'First';
  if (num == 2) return 'Second';
  if (num == 3) return 'Third';
  if (num == 4) return 'Fourth';
  return 'Error';
}

// ─── Form Field ────────────────────────────────────────────────────────────

Widget appTextField({
  required String label,
  required TextEditingController controller,
  bool readOnly = false,
  TextInputType keyboardType = TextInputType.text,
  bool obscure = false,
  String? hint,
  Widget? prefix,
}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: const TextStyle(
          fontSize: 15,
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefix,
        ),
      ),
    );

Widget readOnlyChipField({
  required String label,
  required TextEditingController controller,
}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(
          fontSize: 15,
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Choose below...',
          suffixIcon: const Icon(Icons.arrow_drop_down,
              color: AppTheme.textSecondary),
        ),
      ),
    );
