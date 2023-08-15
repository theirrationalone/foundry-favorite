// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract AddFavoriteNumber is Script {
    function addFavoriteNumber(address _simpleStorageInstanceAddress, uint256 _favoriteNumber) public {
        SimpleStorage(payable(_simpleStorageInstanceAddress)).storeNumber(_favoriteNumber);
    }

    function run() external returns (SimpleStorage simpleStorage) {
        uint256 favoriteNumber = 12;

        vm.startBroadcast();
        simpleStorage = new SimpleStorage();
        vm.stopBroadcast();

        addFavoriteNumber(address(simpleStorage), favoriteNumber);
    }
}

contract AddPerson is Script {
    function addPerson(address _simpleStorageInstanceAddress, string memory _personName, uint256 _personFavoriteNumber)
        public
    {
        SimpleStorage(payable(_simpleStorageInstanceAddress)).addPerson(_personName, _personFavoriteNumber);
    }

    function run() external returns (SimpleStorage simpleStorage) {
        string memory personName = "Anil";
        uint256 personFavoriteNumber = 12;

        vm.startBroadcast();
        simpleStorage = new SimpleStorage();
        vm.stopBroadcast();

        addPerson(address(simpleStorage), personName, personFavoriteNumber);
    }
}
