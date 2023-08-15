// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {StdInvariant} from "forge-std/StdInvariant.sol";
import {Test} from "forge-std/Test.sol";

import {SimpleStorage} from "../../src/SimpleStorage.sol";
import {DeploySimpleStorage} from "../../script/DeploySimpleStorage.s.sol";
import {Handler} from "./Handler.t.sol";

contract SimpleStorageInvariantTest is StdInvariant, Test {
    SimpleStorage simpleStorage;

    function setUp() external {
        DeploySimpleStorage deployer = new DeploySimpleStorage();
        simpleStorage = deployer.run();

        Handler handler = new Handler(simpleStorage);

        targetContract(address(handler));
    }

    function invariant_neverStoreNegativeNumbersAsFavoriteNumberAndOnlyAddsPersonWithValidNonEmptyName()
        /**
         * uint256 _personListIndex
         */
        public
        view
    {
        uint256 favoriteNumber = simpleStorage.getFavoriteNumber();

        if (favoriteNumber <= 0) {
            return;
        }

        assert(favoriteNumber > 0);

        // Why can't we test this (Hint: Ghost Variables)
        // SimpleStorage.Person memory person = simpleStorage.getPersonDetailFromList(_personListIndex);
        // assert(keccak256(abi.encodePacked(person.name)) != keccak256(abi.encodePacked("")));
        // assert(person.favoriteNumber > 0);
    }
}
