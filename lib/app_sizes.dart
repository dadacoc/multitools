import 'package:flutter/material.dart';

/// Définit l'échelle de tailles et les tokens sémantiques pour toute l'application.
class AppSizes {
  // Constructeur privé pour empêcher l'instanciation.
  AppSizes._();

  // --- 1. Les valeurs utilisé ---
  static const double _p4 = 4.0;
  static const double _p8 = 8.0;
  static const double _p12 = 12.0;
  static const double _p16 = 16.0;
  static const double _p24 = 24.0;
  static const double _p32 = 32.0;
  //static const double _p48 = 48.0;
  static const double _p64 = 64.0;

  // --- 2. TOKENS SÉMANTIQUES PAR CONTEXTE ---
  // On utilise des classes imbriquées pour organiser et clarifier l'usage.

  /// Pour les espacements avec `SizedBox`.
  /// Utilisation : `SizedBox(height: AppSizes.gap.s)`
  static const Gap gap = Gap._();

  /// Pour le `padding` des widgets.
  /// Utilisation : `Padding(padding: EdgeInsets.all(AppSizes.padding.m))`
  static const AppPadding padding = AppPadding._();

  /// Pour les `BorderRadius`.
  /// Utilisation : `borderRadius: BorderRadius.circular(AppSizes.corners.m)`
  static const Corners corners = Corners._();

  ///Pour les icon
  static const IconSizes icon = IconSizes._();
}

///Paramètre de divider.
class AppDividers {
  AppDividers._();

  /// Un diviseur standard, fin et subtil, avec un espacement vertical moyen.
  /// La couleur sera gérée par le thème de l'application.
  static const standard = Divider(
    height: AppSizes._p32, // On utilise notre token sémantique pour l'espacement
    thickness: 1.0,
  );

  /// Un diviseur plus léger, avec moins d'espacement.
  static const tight = Divider(
    height: AppSizes._p16,
    thickness: 0.5,
  );
}

/// Définitions sémantiques pour les espacements (Gaps).
class Gap {
  const Gap._();
  final double xs = AppSizes._p4;  // Extra Small
  final double s = AppSizes._p8;   // Small
  final double m = AppSizes._p16;  // Medium
  final double l = AppSizes._p24;  // Large
  final double xl = AppSizes._p32;  // Extra Large
  final double xxl = AppSizes._p64; // Extra Extra Large
}

/// Définitions sémantiques pour le remplissage (Padding).
class AppPadding {
  const AppPadding._();
  final double s = AppSizes._p8;
  final double m = AppSizes._p16;
  final double l = AppSizes._p24;
}

/// Définitions sémantiques pour les coins arrondis (Corners).
class Corners {
  const Corners._();
  final double s = AppSizes._p8;
  final double m = AppSizes._p12;
  final double l = AppSizes._p24;
}

/// Définition pour icon
class IconSizes {
  const IconSizes._();
  final double s = 16.0;
  final double m = 24.0; // Taille standard de Material
  final double l = 32.0;
  final double xl = 48.0;
}