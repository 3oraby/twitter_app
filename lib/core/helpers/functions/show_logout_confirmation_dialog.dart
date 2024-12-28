import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/cubits/logout_cubits/logout_cubit.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_alert_dialog.dart';

void showLogoutConfirmationDialog({
  required BuildContext context,
}) {
  showCustomAlertDialog(
    context: context,
    title: context.tr("Are you sure?"),
    content: context.tr("Do you really want to log out?"),
    okButtonDescription: context.tr("Log Out"),
    onCancelButtonPressed: () {
      Navigator.pop(context);
    },
    onOkButtonPressed: () {
      //! remove user from prefs
      BlocProvider.of<LogoutCubit>(context).logOut();
    },
  );
}
