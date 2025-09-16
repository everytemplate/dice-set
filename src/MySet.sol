// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ObjectIdAuto} from "@everyprotocol/periphery/libraries/Allocator.sol";
import {ISetRegistry, SetRegistryAdmin} from "@everyprotocol/periphery/utils/SetRegistryAdmin.sol";
import {ISetRegistryHook, SetContext, SetRegistryHook} from "@everyprotocol/periphery/utils/SetRegistryHook.sol";
import {Descriptor, ISet, SetSolo} from "@everyprotocol/periphery/utils/SetSolo.sol";

contract MySet is SetSolo, SetRegistryHook, SetRegistryAdmin {
    error KindRevNotSpecified();

    ObjectIdAuto.Storage internal _idAllocator;

    constructor(address setRegistry, uint64 kindId, uint32 kindRev) SetRegistryHook(setRegistry) {
        if (kindRev == 0) revert KindRevNotSpecified();
        SetContext.setKindId(kindId);
        SetContext.setKindRev(kindRev);
    }

    function create(address to, uint64 id0, bytes calldata data)
        external
        override
        returns (uint64 id, Descriptor memory od)
    {
        bytes32[] memory elems = abi.decode(data, (bytes32[]));
        id = ObjectIdAuto.allocate(_idAllocator, id0);
        od = Descriptor(
            0, 1, SetContext.getSetRev(), SetContext.getSetRev(), SetContext.getKindId(), SetContext.getSetId()
        );
        _create(to, id, od, elems);
        _postCreate(to, id, od, elems);
    }

    function update(uint64 id, bytes calldata data) external override returns (Descriptor memory od) {
        bytes32[] memory elems = abi.decode(data, (bytes32[]));
        od = _update(id, elems);
        _postUpdate(id, od, elems);
    }

    function supportsInterface(bytes4 interfaceId) external pure override(SetSolo, SetRegistryHook) returns (bool) {
        return interfaceId == type(ISetRegistryHook).interfaceId || SetSolo._supportsInterface(interfaceId);
    }

    function _objectURI() internal view virtual override returns (string memory) {
        ISetRegistry setr = ISetRegistry(SetContext.getSetRegistry());
        return setr.setURI(SetContext.getSetId());
    }
}
