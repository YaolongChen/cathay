import 'package:flutter/material.dart';

import '../core/localization/localization.dart';

class LoadingErrorView extends StatelessWidget {
  const LoadingErrorView({
    super.key,
    required this.onReloadTap,
    this.reloadButtonText,
    this.tip,
  });

  final String? tip;
  final String? reloadButtonText;
  final VoidCallback onReloadTap;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(),
        Text(tip ?? localization.unknownErrorTip),
        ElevatedButton(
          onPressed: onReloadTap,
          child: Text(
            reloadButtonText ?? localization.loadingErrorViewReloadButton,
          ),
        ),
      ],
    );
  }
}
