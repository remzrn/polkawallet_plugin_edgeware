library polkawallet_plugin_edgeware;

import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:polkawallet_plugin_edgeware/common/constants.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/council/candidateDetailPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/council/candidateListPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/council/councilPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/council/councilVotePage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/council/motionDetailPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/democracy/democracyPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/democracy/proposalDetailPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/democracy/referendumVotePage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/treasury/spendProposalPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/treasury/submitProposalPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/treasury/submitTipPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/treasury/tipDetailPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/governance/treasury/treasuryPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/bondExtraPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/controllerSelectPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/payoutPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/rebondPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/redeemPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/rewardDetailPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/setControllerPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/setPayeePage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/stakePage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/stakingDetailPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/actions/unbondPage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/validators/nominatePage.dart';
import 'package:polkawallet_plugin_edgeware/pages/staking/validators/validatorDetailPage.dart';
import 'package:polkawallet_plugin_edgeware/service/index.dart';
import 'package:polkawallet_plugin_edgeware/store/cache/storeCache.dart';
import 'package:polkawallet_plugin_edgeware/store/index.dart';
import 'package:polkawallet_plugin_edgeware/utils/i18n/index.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/plugin/homeNavItem.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:polkawallet_sdk/utils/i18n.dart';
import 'package:polkawallet_ui/pages/dAppWrapperPage.dart';
import 'package:polkawallet_ui/pages/txConfirmPage.dart';
import 'package:polkawallet_ui/pages/walletExtensionSignPage.dart';

class PluginEdgeware extends PolkawalletPlugin {
  /// the Edgeware plugin supports the Edgeware network
  PluginEdgeware()
      : basic = PluginBasicData(
          name: 'edgeware',
          genesisHash: genesis_hash_edgeware,
          ss58: 7,
          primaryColor: edgeware_jaco_blue,
          gradientColor: Colors.cyan,
          backgroundImage: AssetImage(
              'packages/polkawallet_plugin_edgeware/assets/images/public/bg_edgeware.png'),
          icon: Image.asset(
              'packages/polkawallet_plugin_edgeware/assets/images/public/edgeware.png'),
          iconDisabled: Image.asset(
              'packages/polkawallet_plugin_edgeware/assets/images/public/edgeware_gray.png'),
          jsCodeVersion: 20601,
          isTestNet: false,
        ),
        recoveryEnabled = false,
        _cache = StoreCacheEdgeware();

  @override
  final PluginBasicData basic;

  @override
  final bool recoveryEnabled;

  @override
  List<NetworkParams> get nodeList {
    return _randomList(node_list_edgeware)
        .map((e) => NetworkParams.fromJson(e))
        .toList();
  }

  @override
  final Map<String, Widget> tokenIcons = {
    'EDG': Image.asset(
        'packages/polkawallet_plugin_edgeware/assets/images/tokens/EDG.png'),
  };

  @override
  List<HomeNavItem> getNavItems(BuildContext context, Keyring keyring) {
    return home_nav_items.map((e) {
      final dic = I18n.of(context).getDic(i18n_full_dic_edgeware, 'common');
      return HomeNavItem(
        text: dic[e],
        icon: SvgPicture.asset(
          'packages/polkawallet_plugin_edgeware/assets/images/public/nav_$e.svg',
          color: Theme.of(context).disabledColor,
        ),
        iconActive: SvgPicture.asset(
          'packages/polkawallet_plugin_edgeware/assets/images/public/nav_$e.svg',
          color: basic.primaryColor,
        ),
        content: e == 'staking' ? Staking(this, keyring) : Gov(this),
      );
    }).toList();
  }

  @override
  Map<String, WidgetBuilder> getRoutes(Keyring keyring) {
    return {
      TxConfirmPage.route: (_) =>
          TxConfirmPage(this, keyring, _service.getPassword),

      // staking pages
      StakePage.route: (_) => StakePage(this, keyring),
      BondExtraPage.route: (_) => BondExtraPage(this, keyring),
      ControllerSelectPage.route: (_) => ControllerSelectPage(this, keyring),
      SetControllerPage.route: (_) => SetControllerPage(this, keyring),
      UnBondPage.route: (_) => UnBondPage(this, keyring),
      RebondPage.route: (_) => RebondPage(this, keyring),
      SetPayeePage.route: (_) => SetPayeePage(this, keyring),
      RedeemPage.route: (_) => RedeemPage(this, keyring),
      PayoutPage.route: (_) => PayoutPage(this, keyring),
      NominatePage.route: (_) => NominatePage(this, keyring),
      StakingDetailPage.route: (_) => StakingDetailPage(this, keyring),
      RewardDetailPage.route: (_) => RewardDetailPage(this, keyring),
      ValidatorDetailPage.route: (_) => ValidatorDetailPage(this, keyring),

      // governance pages
      DemocracyPage.route: (_) => DemocracyPage(this, keyring),
      ReferendumVotePage.route: (_) => ReferendumVotePage(this, keyring),
      CouncilPage.route: (_) => CouncilPage(this, keyring),
      CouncilVotePage.route: (_) => CouncilVotePage(this),
      CandidateListPage.route: (_) => CandidateListPage(this, keyring),
      CandidateDetailPage.route: (_) => CandidateDetailPage(this, keyring),
      MotionDetailPage.route: (_) => MotionDetailPage(this, keyring),
      ProposalDetailPage.route: (_) => ProposalDetailPage(this, keyring),
      TreasuryPage.route: (_) => TreasuryPage(this, keyring),
      SpendProposalPage.route: (_) => SpendProposalPage(this, keyring),
      SubmitProposalPage.route: (_) => SubmitProposalPage(this, keyring),
      SubmitTipPage.route: (_) => SubmitTipPage(this, keyring),
      TipDetailPage.route: (_) => TipDetailPage(this, keyring),
      DAppWrapperPage.route: (_) => DAppWrapperPage(this, keyring),
      WalletExtensionSignPage.route: (_) =>
          WalletExtensionSignPage(this, keyring, _service.getPassword),
    };
  }

  @override
  Future<String> loadJSCode() => rootBundle.loadString(
      'packages/polkawallet_plugin_edgeware/lib/js_api_edgeware/dist/main.js');

  PluginStore _store;
  PluginApi _service;
  PluginStore get store => _store;
  PluginApi get service => _service;

  final StoreCache _cache;

  @override
  Future<void> onWillStart(Keyring keyring) async {
    await GetStorage.init(plugin_edgeware_storage_key);

    _store = PluginStore(_cache);

    try {
      _store.staking.loadCache(keyring.current.pubKey);
      _store.gov.clearState();
      _store.gov.loadCache();
      print('edgeware plugin cache data loaded');
    } catch (err) {
      print(err);
      print('load edgeware cache data failed');
    }

    _service = PluginApi(this, keyring);
  }

  @override
  Future<void> onStarted(Keyring keyring) async {
    _service.staking.queryElectedInfo();
  }

  @override
  Future<void> onAccountChanged(KeyPairData acc) async {
    _store.staking.loadAccountCache(acc.pubKey);
  }

  List _randomList(List input) {
    final data = input.toList();
    final res = List();
    final _random = Random();
    for (var i = 0; i < input.length; i++) {
      final item = data[_random.nextInt(data.length)];
      res.add(item);
      data.remove(item);
    }
    return res;
  }
}
