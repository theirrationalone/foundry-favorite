// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {SimpleStorage} from "../../src/SimpleStorage.sol";

contract Handler is Test {
    SimpleStorage private immutable i_simpleStorage;

    constructor(SimpleStorage _simpleStorage) {
        i_simpleStorage = _simpleStorage;
    }

    function storeNumber(uint256 _numberSeed) public {
        uint256 favoriteNumber = bound(_numberSeed, 1, type(uint256).max);

        i_simpleStorage.storeNumber(favoriteNumber);
    }
}

// function addPerson(string calldata _nameSeed, uint256 _favoriteNumberSeed) public {
//     if ((_favoriteNumberSeed <= 0) || (keccak256(abi.encodePacked(_nameSeed)) == keccak256(abi.encodePacked("")))) {
//         console.log("we're going through this...");
//         return;
//     }

//     i_simpleStorage.addPerson(_nameSeed, _favoriteNumberSeed);
// }
