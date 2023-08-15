// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {SimpleStorage} from "../../src/SimpleStorage.sol";
import {DeploySimpleStorage} from "../../script/DeploySimpleStorage.s.sol";
import {AddFavoriteNumber, AddPerson} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    SimpleStorage private s_simpleStorage;

    address USER = makeAddr("USER");

    function setUp() external {
        DeploySimpleStorage deployer = new DeploySimpleStorage();

        s_simpleStorage = deployer.run();
    }

    function testStoreFavoriteNumberAndAddPersonWithStoredFavoriteNumber() public {
        uint256 expectedFavoriteNumber = 121;
        string memory expectedPersonName = "Arien";

        AddFavoriteNumber addFavoriteNumber = new AddFavoriteNumber();
        vm.startPrank(USER);
        addFavoriteNumber.addFavoriteNumber(address(s_simpleStorage), expectedFavoriteNumber);
        vm.stopPrank();

        AddPerson addPerson = new AddPerson();
        vm.startPrank(USER);
        addPerson.addPerson(address(s_simpleStorage), expectedPersonName, expectedFavoriteNumber);
        vm.stopPrank();

        uint256 actualFavoriteNumber = s_simpleStorage.getFavoriteNumber();
        SimpleStorage.Person memory person = s_simpleStorage.getPersonDetailFromList(0);
        uint256 actualPersonFavoriteNumber = s_simpleStorage.getPersonFavoriteNumber(person.name);

        assertEq(actualFavoriteNumber, expectedFavoriteNumber);
        assertEq(person.favoriteNumber, expectedFavoriteNumber);
        assertEq(person.favoriteNumber, actualPersonFavoriteNumber);
        assertEq(person.favoriteNumber, actualFavoriteNumber);
        assertEq(actualFavoriteNumber, actualPersonFavoriteNumber);
        assertEq(keccak256(abi.encodePacked(person.name)), keccak256(abi.encodePacked(expectedPersonName)));
    }
}
