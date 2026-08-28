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

pragma solidity 0.8.7;

import "./interfaces/IGlobalStorage.sol";
import "../utils/proxy/ExternalStorage.sol";

contract GlobalStorage is ExternalStorage, IGlobalStorage {

    bytes32 public constant WHITELISTED_ROLE = keccak256("WHITELISTED_ROLE");

    mapping(bytes32 => address) private _addresses;
    mapping(address => bool) public override products;

    event AddAddress(bytes32 key, address indexed value);

    constructor() {
        _setupRole(WHITELISTED_ROLE, msg.sender);
    }

    function set(bytes32 key, address value) public override onlyRole(WHITELISTED_ROLE) {
        require(address(0) != value, 'address cannot be zero');
        _addresses[key] = value;
        products[value] = true;
        emit AddAddress(key, value);
    }

    function get(bytes32 key) view external override returns(address) {
        return _addresses[key];
    }
}
