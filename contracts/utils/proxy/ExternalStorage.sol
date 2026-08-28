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

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

abstract contract ExternalStorage is AccessControlEnumerable, Pausable {

    bytes32 public constant WRITE_ROLE = keccak256("WRITE_ROLE");
    bytes32 public constant READ_ROLE = keccak256("READ_ROLE");

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(WRITE_ROLE, msg.sender);
        _setupRole(READ_ROLE, msg.sender);
    }

    modifier onlyWriter() {
        _checkRole(WRITE_ROLE, msg.sender);
        require(!paused(), "Pausable: paused");
        _;
    }

    modifier onlyReader() {
        _checkRole(READ_ROLE, msg.sender);
        _;
    }

    function checkRole(bytes32 role, address account) external view {
        _checkRole(role, account);
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }
}
