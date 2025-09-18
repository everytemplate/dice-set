// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ObjectIdAuto} from "@everyprotocol/periphery/libraries/Allocator.sol";
import {ISetRegistry, SetRegistryAdmin} from "@everyprotocol/periphery/utils/SetRegistryAdmin.sol";
import {ISetRegistryHook, SetContext, SetRegistryHook} from "@everyprotocol/periphery/utils/SetRegistryHook.sol";
import {Descriptor, ISet, SetSolo} from "@everyprotocol/periphery/utils/SetSolo.sol";

contract DiceSet is SetSolo, SetRegistryHook, SetRegistryAdmin {
    using ObjectIdAuto for ObjectIdAuto.Storage;

    error KindNotSpecified();
    error SetNotAssigned();

    ObjectIdAuto.Storage internal _idManager;

    constructor(address setRegistry, uint64 kindId, uint32 kindRev) SetRegistryHook(setRegistry) {
        if (kindRev == 0 || kindId == 0) revert KindNotSpecified();
        SetContext.setKindId(kindId);
        SetContext.setKindRev(kindRev);
    }

    function mint(address to, uint64 id0) external returns (uint64 id, Descriptor memory desc) {
        (uint64 setId, uint32 setRev) = (SetContext.getSetId(), SetContext.getSetRev());
        if (setId == 0 || setRev == 0) revert SetNotAssigned();
        (uint64 kindId, uint32 kindRev) = (SetContext.getKindId(), SetContext.getKindRev());
        if (kindId == 0 || kindRev == 0) revert KindNotSpecified();
        desc = Descriptor({traits: 0, rev: 1, setRev: setRev, kindRev: kindRev, kindId: kindId, setId: setId});

        id = _idManager.allocate(id0);
        bytes32[] memory elems = new bytes32[](1);
        elems[0] = _roll();

        _create(to, id, desc, elems);
        _postCreate(to, id, desc, elems);
    }

    function roll(uint64 id, uint256 face) external returns (Descriptor memory od) {
        bytes32[] memory elems = new bytes32[](1);
        elems[0] = bytes32(face);
        od = _update(id, elems);
        _postUpdate(id, od, elems);
    }

    function roll(uint64 id) external returns (Descriptor memory od) {
        bytes32[] memory elems = new bytes32[](1);
        elems[0] = _roll();
        od = _update(id, elems);
        _postUpdate(id, od, elems);
    }

    function _roll() internal view returns (bytes32) {
        return keccak256(abi.encodePacked(block.prevrandao, tx.origin, gasleft()));
    }

    function supportsInterface(bytes4 interfaceId) external pure override(SetSolo, SetRegistryHook) returns (bool) {
        return interfaceId == type(ISetRegistryHook).interfaceId || SetSolo._supportsInterface(interfaceId);
    }

    function _objectURI() internal view virtual override returns (string memory) {
        ISetRegistry setr = ISetRegistry(SetContext.getSetRegistry());
        return setr.setURI(SetContext.getSetId());
    }
}
