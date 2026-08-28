// SPDX-License-Identifier: MIT
//                       ...`
//                   :sdmdhhdNy.
//                .sNh/.   `ydyM+
//              .sNy.     /m+  sM-
//         .+ymmhyN:    `hh.   .My                        .:-                                           .-.
//       +dmsydy+.-mo  /m+     `MMmo`                     oMM                  -hh`                     yMy
//     .mm:    `/shdMhhh.      -Mo-hN:    .+sso-  +o:  ++ oMM  :oss+.  oo/ss   :yMMo  /sys/      /sys/  yMy `/ss+-
//     mm`         `:NMmhyo/.  yM.  hM`   +Mm  Mh NMo  mM oMM +Mm   Mh MMNso   :hMMs -NMy+sMN- -NMy+sMN yMy NM
//     Nm           .Mom+`-/oydMo   yM.  NMdyyyMM NMo  mM oMM MMyssdMN MM/     :MM` yMd   dMh yMd   dMh oyz smNyo:
//     :Nh.         +N `dy`  .Nh  `sM+   dMh      My .NMs MM- dMh      MM:     :MM-  oMN. .NM  oMN. .NM yMy    dMy
//      `sNh+.      ds   sm--Nh./yNy-    `yNNmMmo /NMNNNM oMN :dMmmMh: MM- /Nd `yNM  omMNMmo   omMNMmo  sNs ymmmNd:
//         +MNmhso//M+---:yMMMNmy/`
//          mm`.:/ossyyyyNMm/-`
//          -Nh.      .omm/
//           .sNdssshmds-
//              .:::-`

pragma solidity ^0.8.7;

import "@openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";
import "../utils/EulerContract.sol";
import "./ManagerTaxStorage.sol";

contract ManagerTax is ManagerTaxStorage, EulerContract {

  function init(address globalStorage, address creator) external virtual initializer {
    _grantRole(DEFAULT_ADMIN_ROLE, creator);
    __EulerContract_init(globalStorage);
  }

  function setMembership(address _membership) external override onlyRole(DEFAULT_ADMIN_ROLE) {
    require(IERC165Upgradeable(_membership).supportsInterface(type(IERC1155Upgradeable).interfaceId),
      'NOT_ERC1155');
    membership = _membership;
    emit SetMembership(_membership);
  }

  function addTax(address _service, Tax memory _tax) public override onlyRole(DEFAULT_ADMIN_ROLE) {
    taxes[_service][_tax.method] = _tax;
    emit AddTax(_service, _tax.method, _tax.regular, _tax.withSubscription);
  }

  function addTaxes(address _service,  Tax[] memory _taxes) external override onlyRole(DEFAULT_ADMIN_ROLE) {
    for(uint256 i = 0; i < _taxes.length; i++) {
      addTax(_service, _taxes[i]);
    }
  }

  function tax(address _service, bytes4 _method, address _account) external override view returns(uint256 _tax, bool _buyback) {

    Tax memory _taxService = taxes[_service][_method];
    _buyback = _taxService.buyback;

    if(membership != address(0) && IERC1155Upgradeable(membership).balanceOf(_account, 0) > 0) {
      _tax = _taxService.withSubscription;
    } else {
      _tax = _taxService.regular;
    }
  }
}
