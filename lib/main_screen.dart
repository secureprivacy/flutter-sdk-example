import 'dart:io';

import 'package:example_mobile_consent/app_config.dart';
import 'package:example_mobile_consent/support/widgets/sp_button.dart';
import 'package:example_mobile_consent/support/widgets/sp_radio_list_tile.dart';
import 'package:example_mobile_consent/support/widgets/sp_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_privacy_mobile_consent/data/dto.dart';
import 'package:secure_privacy_mobile_consent/data/enums/sp_consent_status.dart';
import 'package:secure_privacy_mobile_consent/secure_privacy_mobile_consent.dart';
import 'package:secure_privacy_mobile_consent/support/logging/sp_logger.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static final _kTag = "_MainScreenState";

  final _spMobileConsent = SecurePrivacyMobileConsent();

  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    final result = await _spMobileConsent.getBuildVersion();
    if (!mounted) return;
    SPLogger.d(_kTag, "initPlatformState()=>$result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _isLoading
              ? _LoadingWidget()
              : _error.isNotEmpty
              ? _ErrorWidget(error: _error, onRetryTap: _onInitialiseTap)
              : _spMobileConsent.isInitialised
              ? _MainContent(_onSessionCleared)
              : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: SPButton(
                    label: "Initialise SDK",
                    onTap: _onInitialiseTap,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _onInitialiseTap() async {
    setState(() => _isLoading = true);

    final result = await _spMobileConsent.initialiseSDK(
      android: SPAuthKey(
        applicationId: AppConfig.applicationIdAndroid,
        secondaryApplicationId: AppConfig.secondaryApplicationIdAndroid,
      ),
      ios: SPAuthKey(
        applicationId: AppConfig.applicationIdIOS,
        secondaryApplicationId: AppConfig.secondaryApplicationIdIOS,
      ),
    );
    SPLogger.d(_kTag, "onInitialiseTap()=>$result");

    if (!mounted) return;

    setState(() => _isLoading = false);
  }

  void _onSessionCleared() {
    if (mounted) setState(() {});
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(radius: 24),
          const SizedBox(height: 16),
          Text(
            "   Initialising...",
            style: const TextStyle(fontSize: 18, fontFamily: ""),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final Future Function() onRetryTap;

  const _ErrorWidget({required this.error, required this.onRetryTap});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: error.isNotEmpty,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(error),
            SPButton(label: "Retry?", onTap: onRetryTap),
          ],
        ),
      ),
    );
  }
}

class _MainContent extends StatefulWidget {
  final VoidCallback onSessionCleared;

  const _MainContent(this.onSessionCleared);

  @override
  State<_MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<_MainContent> {
  static const _kTag = "_MainContentState";
  static const _primaryAppConsentEventCode = 101;
  static const _secondaryAppConsentEventCode = 102;

  final _spMobileConsent = SecurePrivacyMobileConsent();

  String _selectedAppId = AppConfig.primaryAppId;
  SPConsentStatus _consentStatus = SPConsentStatus.pending;
  String _packageId = "";
  String? _packageStatusLabel;
  String? _primarySubtitle, _secondarySubtitle;

  @override
  void initState() {
    super.initState();
    _renderAppInfo();
    _onCheckConsentStatus();
    _spMobileConsent.consentEventStream.listen((event) {
      if ([
        _primaryAppConsentEventCode,
        _secondaryAppConsentEventCode,
      ].contains(event.data?.code)) {
        _onCheckConsentStatus();
      }
    });
    _spMobileConsent.addListener(
      Platform.isAndroid
          ? AppConfig.applicationIdAndroid
          : Platform.isIOS
          ? AppConfig.applicationIdIOS
          : "",
      _primaryAppConsentEventCode,
    );
    _spMobileConsent.addListener(
      Platform.isAndroid
          ? AppConfig.secondaryApplicationIdAndroid
          : Platform.isIOS
          ? AppConfig.secondaryApplicationIdIOS
          : "",
      _secondaryAppConsentEventCode,
    );
  }

  @override
  void dispose() {
    _spMobileConsent.removeListener(_primaryAppConsentEventCode);
    _spMobileConsent.removeListener(_secondaryAppConsentEventCode);
    super.dispose();
  }

  Future<void> _renderAppInfo() async {
    final primaryAppLocale = await _spMobileConsent.getLocale(
      AppConfig.primaryAppId,
    );
    final primaryAppClientId = await _spMobileConsent.getClientId(
      AppConfig.primaryAppId,
    );
    final secondaryAppLocale = await _spMobileConsent.getLocale(
      AppConfig.secondaryAppId,
    );
    final secondaryAppClientId = await _spMobileConsent.getClientId(
      AppConfig.secondaryAppId,
    );
    setState(() {
      _primarySubtitle =
          "(${primaryAppLocale.data}) ${primaryAppClientId.data}";
      _secondarySubtitle =
          "(${secondaryAppLocale.data}) ${secondaryAppClientId.data}";
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        padding: EdgeInsets.only(
          top: kToolbarHeight * 1.25,
          bottom: kToolbarHeight,
        ),
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
            children: [
              const TextSpan(
                text: 'SDK Status: ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
              TextSpan(
                text: "Initialised",
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      Text(
        'Application Type',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
      ),
      const SizedBox(height: 8),
      SPRadioListTile(
        value: AppConfig.primaryAppId,
        groupValue: _selectedAppId,
        onChange: (appId) {
          setState(() => _selectedAppId = appId);
          _onCheckConsentStatus();
        },
        title: "Primary",
        subTitle: _primarySubtitle,
      ),
      SPRadioListTile(
        value: AppConfig.secondaryAppId,
        groupValue: _selectedAppId,
        onChange: (appId) {
          setState(() => _selectedAppId = appId);
          _onCheckConsentStatus();
        },
        title: "Secondary",
        subTitle: _secondarySubtitle,
      ),
      Container(
        padding: EdgeInsets.only(top: 24, bottom: 2),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(fontSize: 15),
                  children: [
                    const TextSpan(
                      text: 'Consent Status: ',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: _consentStatus.rawValue,
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: _onCheckConsentStatus,
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      SPButton(label: "Consent Banner", onTap: _onConsentBannerTap),
      SPButton(label: "Preference Center", onTap: _onPreferenceCenterTap),
      SPTextField(
        label: _packageStatusLabel ?? "Please enter a package name",
        hint: "com.google.ads.mediation:facebook",
        onChange: (packageName) => _packageId = packageName,
      ),
      SPButton(label: "Check package status", onTap: _onCheckPackageStatus),
      SPButton(label: "Clear session", onTap: _onClearSessionTap),
    ],
  );

  Future<void> _onCheckConsentStatus() async {
    final result = await _spMobileConsent.getConsentStatus(_selectedAppId);
    SPLogger.d(_kTag, "_onCheckConsentStatusTap($_selectedAppId)=>$result");
    if (!mounted) return;
    setState(() {
      if (result.code == 200 && result.data != null) {
        _consentStatus = result.data!;
      }
    });
  }

  Future<void> _onConsentBannerTap() async {
    if (_selectedAppId == AppConfig.primaryAppId) {
      final result = await _spMobileConsent.showConsentBanner();
      SPLogger.d(_kTag, "primary===> ${result.msg}");
    } else if (_selectedAppId == AppConfig.secondaryAppId) {
      final result = await _spMobileConsent.showSecondaryBanner();
      SPLogger.d(_kTag, "secondary===> $result");
    }
  }

  Future<void> _onPreferenceCenterTap() =>
      _spMobileConsent.showPreferenceCenter(_selectedAppId);

  Future<void> _onCheckPackageStatus() async {
    final pkgId = _packageId.trim();
    if (pkgId.isEmpty) {
      setState(() => _packageStatusLabel = null);
      return;
    }

    final result = await _spMobileConsent.getPackage(
      _selectedAppId,
      _packageId,
    );
    if (!mounted) return;
    if (result.data != null) {
      setState(
        () => _packageStatusLabel =
            "Package status: ${result.data!.enabled ? "Enabled" : "Disabled"}!",
      );
    } else if (result.code == 404) {
      setState(() => _packageStatusLabel = "Consent data not found!");
    } else if (result.code == 200 && result.data == null) {
      setState(() => _packageStatusLabel = "Package not found!");
    } else {
      setState(() => _packageStatusLabel = result.msg);
    }
  }

  Future<void> _onClearSessionTap() async {
    await _spMobileConsent.clearSession();
    _selectedAppId = AppConfig.primaryAppId;
    widget.onSessionCleared();
  }
}
