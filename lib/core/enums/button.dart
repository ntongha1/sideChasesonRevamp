import 'package:sonalysis/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sonalysis/core/utils/styles.dart';

enum ButtonType { primary, secondary, tertiary, deleteButton }

extension ButtonTypeExt on ButtonType {
  LinearGradient get defaultGradient {
    switch (this) {
      case ButtonType.primary:
        return AppColors.sonalysisPrimaryButtonGradient;
      case ButtonType.secondary:
        return AppColors.sonalysisSecondaryButtonGradient;
      case ButtonType.tertiary:
        return AppColors.sonalysisTertiaryButtonGradient;
      case ButtonType.deleteButton:
        return AppColors.sonalysisTertiaryButtonGradient;
    }
  }

  Color get defaultColor {
    switch (this) {
      case ButtonType.primary:
        return Colors.transparent;
      case ButtonType.secondary:
        return AppColors.sonaGrey6;
      case ButtonType.tertiary:
        return Colors.transparent;
      case ButtonType.deleteButton:
        return Colors.transparent;
    }
  }

  LinearGradient get disabledColorGradient {
    switch (this) {
      case ButtonType.primary:
        return AppColors.sonalysisPrimaryButtonDisabledColorGradient;
      case ButtonType.secondary:
        return AppColors.sonalysisSecondaryButtonGradient;
      case ButtonType.tertiary:
        return AppColors.sonalysisTertiaryButtonGradient;
      case ButtonType.deleteButton:
        return AppColors.sonalysisTertiaryButtonGradient;
    }
  }

  Color get disabledColor {
    switch (this) {
      case ButtonType.primary:
        return AppColors.sonaGrey6.withOpacity(0.7);
      case ButtonType.secondary:
        return AppColors.sonaGrey6.withOpacity(0.7);
      case ButtonType.tertiary:
        return Colors.transparent;
      case ButtonType.deleteButton:
        return Colors.transparent;
    }
  }

  Color get borderColor {
    switch (this) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.tertiary:
      case ButtonType.deleteButton:
        return Colors.transparent;
    }
  }

  Color get defaultTextColor {
    switch (this) {
      case ButtonType.primary:
        return AppColors.sonaWhite;
      case ButtonType.secondary:
        return AppColors.sonaBlack2;
      case ButtonType.tertiary:
        return AppColors.sonaBlack2;
      case ButtonType.deleteButton:
        return AppColors.sonaRed;
    }
  }

  Color get disableTextColor {
    switch (this) {
      case ButtonType.primary:
        return AppColors.sonaWhite;
      case ButtonType.secondary:
        return AppColors.sonaBlack2;
      case ButtonType.tertiary:
        return AppColors.sonaBlack2;
      case ButtonType.deleteButton:
        return AppColors.sonaBlack2;
    }
  }

  TextStyle get buttonStyle {
    switch (this) {
      case ButtonType.primary:
        return AppStyle.buttonText;
      case ButtonType.secondary:
        return AppStyle.buttonText.copyWith(color: AppColors.sonaBlack2);
      case ButtonType.tertiary:
        return AppStyle.buttonText.copyWith(color: AppColors.sonaBlack2);
      case ButtonType.deleteButton:
        return AppStyle.buttonText.copyWith(color: AppColors.sonaRed);
    }
  }

  TextStyle get disabledTextColor {
    switch (this) {
      case ButtonType.primary:
        return AppStyle.buttonText.copyWith(color: AppColors.sonaWhite);
      case ButtonType.secondary:
        return AppStyle.buttonText
            .copyWith(color: AppColors.sonaBlack2.withOpacity(0.4));
      case ButtonType.tertiary:
        return AppStyle.buttonText
            .copyWith(color: AppColors.sonaBlack2.withOpacity(0.4));
      case ButtonType.deleteButton:
        return AppStyle.buttonText
            .copyWith(color: AppColors.sonaBlack2.withOpacity(0.4));
    }
  }
}
