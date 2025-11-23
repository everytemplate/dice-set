// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SetLinked, Descriptor} from "@everyprotocol/periphery/sets/SetLinked.sol";

contract DiceSet1155 is SetLinked {
    error KindNotSpecified();
    error KindRevUnavailable();
    error SetNotRegistered();
    error ObjectIdAutoOnly();

    uint64 _minted;
    uint64 _kindId;
    uint32 _kindRev;

    constructor(address setRegistry, uint64 kindId, uint32 kindRev) {
        _SetLinked_initializeFrom(setRegistry);
        if (kindRev == 0) revert KindNotSpecified();
        _kindId = kindId;
        _kindRev = kindRev;
    }

    function mint(address to, uint64 id0, bytes memory) external returns (uint64 id, Descriptor memory desc) {
        if (id0 != 0) revert ObjectIdAutoOnly();
        id = ++_minted;

        (uint64 setId, uint32 setRev) = SetLinked.getSetIdRev();
        if (setId == 0 || setRev == 0) revert SetNotRegistered();
        uint32 kindRev = SetLinked.checkKindRev(_kindId, _kindRev);
        if (kindRev == 0) revert KindRevUnavailable();

        desc = Descriptor({traits: 0, rev: 1, setRev: setRev, kindRev: kindRev, kindId: _kindId, setId: setId});
        bytes32[] memory elems = new bytes32[](1);
        elems[0] = _random();

        _create(to, id, desc, elems);
        _postCreate(to, id, desc, elems);
    }

    function roll(uint64 id, uint256 face) external returns (Descriptor memory desc) {
        bytes32[] memory elems = new bytes32[](1);
        elems[0] = bytes32(face);
        desc = _update(id, elems);
        _postUpdate(id, desc, elems);
    }

    function roll(uint64 id) external returns (Descriptor memory desc) {
        bytes32[] memory elems = new bytes32[](1);
        elems[0] = _random();
        desc = _update(id, elems);
        _postUpdate(id, desc, elems);
    }

    function _random() internal view returns (bytes32) {
        /// forge-lint: disable-next-item(asm-keccak256)
        return keccak256(abi.encodePacked(block.prevrandao, tx.origin, gasleft()));
    }
}
