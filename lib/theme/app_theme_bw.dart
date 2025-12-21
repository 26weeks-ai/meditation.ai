import 'package:flutter/material.dart';

class AppColorsBW {
  static const Color backgroundPrimary = Color(0xFF0B0D10);
  static const Color backgroundSecondary = Color(0xFF11151A);
  static const Color surface = Color(0xFF141A21);
  static const Color surfaceElevated = Color(0xFF1A2230);
  static const Color border = Color(0xFF2A3340);
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFFC7CFDA);
  static const Color textMuted = Color(0xFF8B97A7);
  static const Color disabled = Color(0xFF475467);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  static const Color shadowSoft = Color(0x1A000000);
  static const Color transparent = Color(0x00000000);
}

class AppThemeBW {
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorsBW.pureWhite,
    onPrimary: AppColorsBW.pureBlack,
    primaryContainer: AppColorsBW.surfaceElevated,
    onPrimaryContainer: AppColorsBW.textPrimary,
    secondary: AppColorsBW.textSecondary,
    onSecondary: AppColorsBW.pureBlack,
    secondaryContainer: AppColorsBW.surfaceElevated,
    onSecondaryContainer: AppColorsBW.textPrimary,
    tertiary: AppColorsBW.textMuted,
    onTertiary: AppColorsBW.pureBlack,
    tertiaryContainer: AppColorsBW.backgroundSecondary,
    onTertiaryContainer: AppColorsBW.textPrimary,
    error: AppColorsBW.textMuted,
    onError: AppColorsBW.pureBlack,
    errorContainer: AppColorsBW.backgroundSecondary,
    onErrorContainer: AppColorsBW.textPrimary,
    surface: AppColorsBW.surface,
    onSurface: AppColorsBW.textPrimary,
    surfaceDim: AppColorsBW.backgroundPrimary,
    surfaceBright: AppColorsBW.surface,
    surfaceContainerLowest: AppColorsBW.backgroundPrimary,
    surfaceContainerLow: AppColorsBW.backgroundSecondary,
    surfaceContainer: AppColorsBW.surface,
    surfaceContainerHigh: AppColorsBW.surface,
    surfaceContainerHighest: AppColorsBW.surfaceElevated,
    onSurfaceVariant: AppColorsBW.textSecondary,
    outline: AppColorsBW.border,
    outlineVariant: AppColorsBW.border,
    shadow: AppColorsBW.shadowSoft,
    scrim: AppColorsBW.pureBlack,
    inverseSurface: AppColorsBW.textPrimary,
    onInverseSurface: AppColorsBW.pureBlack,
    inversePrimary: AppColorsBW.pureBlack,
    surfaceTint: AppColorsBW.surfaceElevated,
  );

  static ThemeData dark() {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    final textTheme = base.textTheme
        .copyWith(
          displayLarge: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.4,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
          labelLarge: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        )
        .apply(
          bodyColor: AppColorsBW.textPrimary,
          displayColor: AppColorsBW.textPrimary,
        );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColorsBW.backgroundPrimary,
      textTheme: textTheme,
      disabledColor: AppColorsBW.disabled,
      dividerTheme: const DividerThemeData(
        color: AppColorsBW.border,
        thickness: 1,
        space: 24,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorsBW.backgroundPrimary,
        foregroundColor: AppColorsBW.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColorsBW.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColorsBW.textPrimary),
      ),
      iconTheme: const IconThemeData(color: AppColorsBW.textPrimary),
      cardTheme: CardThemeData(
        color: AppColorsBW.surface,
        elevation: 1,
        shadowColor: AppColorsBW.shadowSoft,
        surfaceTintColor: AppColorsBW.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColorsBW.border),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(52)),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? AppColorsBW.disabled
                : AppColorsBW.pureWhite,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? AppColorsBW.textMuted
                : AppColorsBW.pureBlack,
          ),
          overlayColor: WidgetStateProperty.all(
            AppColorsBW.pureBlack.withValues(alpha: 0.08),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(52)),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? AppColorsBW.disabled
                : AppColorsBW.textPrimary,
          ),
          side: WidgetStateProperty.resolveWith(
            (states) => BorderSide(
              color: states.contains(WidgetState.disabled)
                  ? AppColorsBW.disabled
                  : AppColorsBW.border,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? AppColorsBW.disabled
                : AppColorsBW.textSecondary,
          ),
          overlayColor: WidgetStateProperty.all(
            AppColorsBW.textPrimary.withValues(alpha: 0.08),
          ),
          textStyle: WidgetStateProperty.all(textTheme.labelLarge),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColorsBW.transparent,
        selectedColor: AppColorsBW.pureWhite,
        secondarySelectedColor: AppColorsBW.pureWhite,
        disabledColor: AppColorsBW.surfaceElevated,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: AppColorsBW.textPrimary,
        ),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: AppColorsBW.pureBlack,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColorsBW.border),
        ),
        side: const BorderSide(color: AppColorsBW.border),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColorsBW.textMuted,
        inactiveTrackColor: AppColorsBW.border,
        thumbColor: AppColorsBW.pureWhite,
        overlayColor: AppColorsBW.pureWhite.withValues(alpha: 0.1),
        activeTickMarkColor: AppColorsBW.textMuted,
        inactiveTickMarkColor: AppColorsBW.textMuted,
        valueIndicatorColor: AppColorsBW.surfaceElevated,
        valueIndicatorTextStyle: textTheme.labelMedium?.copyWith(
          color: AppColorsBW.textPrimary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColorsBW.disabled;
            }
            return states.contains(WidgetState.selected)
                ? AppColorsBW.pureWhite
                : AppColorsBW.textMuted;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColorsBW.border;
            }
            return states.contains(WidgetState.selected)
                ? AppColorsBW.border
                : AppColorsBW.surfaceElevated;
          },
        ),
        trackOutlineColor: WidgetStateProperty.all(AppColorsBW.border),
        overlayColor: WidgetStateProperty.all(
          AppColorsBW.pureWhite.withValues(alpha: 0.08),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStateProperty.all(textTheme.labelLarge),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColorsBW.transparent;
              }
              return states.contains(WidgetState.selected)
                  ? AppColorsBW.pureWhite
                  : AppColorsBW.transparent;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColorsBW.disabled;
              }
              return states.contains(WidgetState.selected)
                  ? AppColorsBW.pureBlack
                  : AppColorsBW.textPrimary;
            },
          ),
          side: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return const BorderSide(color: AppColorsBW.disabled);
              }
              return BorderSide(
                color: states.contains(WidgetState.selected)
                    ? AppColorsBW.pureWhite
                    : AppColorsBW.border,
              );
            },
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColorsBW.pureWhite,
        linearTrackColor: AppColorsBW.border,
        circularTrackColor: AppColorsBW.border,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColorsBW.textPrimary,
        textColor: AppColorsBW.textPrimary,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColorsBW.textSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsBW.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColorsBW.textMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColorsBW.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColorsBW.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColorsBW.textSecondary),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColorsBW.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColorsBW.textPrimary,
        ),
      ),
    );
  }
}
