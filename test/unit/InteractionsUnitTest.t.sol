// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {SimpleStorage} from "../../src/SimpleStorage.sol";
import {AddFavoriteNumber, AddPerson} from "../../script/Interactions.s.sol";

contract InteractionsUnitTest is Test {
    SimpleStorage private s_favNum_simpleStorage;
    SimpleStorage private s_addPsn_simpleStorage;

    uint256 private constant EXPT_PSN_FAV_NUM = 12;
    string private constant EXPT_PSN_NAME = "Anil";

    AddPerson addPerson = new AddPerson();
    AddFavoriteNumber addFavoriteNumber = new AddFavoriteNumber();

    function setUp() external {
        // nothing to do
    }

    function testAddFavoriteNumberScript() public {
        s_favNum_simpleStorage = addFavoriteNumber.run();
        uint256 actualFavoriteNumber = s_favNum_simpleStorage.getFavoriteNumber();

        assertEq(actualFavoriteNumber, EXPT_PSN_FAV_NUM);
    }

    function testAddPersonScript() public {
        s_addPsn_simpleStorage = addPerson.run();

        SimpleStorage.Person memory person = s_addPsn_simpleStorage.getPersonDetailFromList(0);
        uint256 actualPersonFavoriteNumber = s_addPsn_simpleStorage.getPersonFavoriteNumber(person.name);

        assertEq(actualPersonFavoriteNumber, EXPT_PSN_FAV_NUM);
        assertEq(person.favoriteNumber, EXPT_PSN_FAV_NUM);
        assertEq(person.favoriteNumber, actualPersonFavoriteNumber);
        assertEq(keccak256(abi.encodePacked(person.name)), keccak256(abi.encodePacked(EXPT_PSN_NAME)));
    }
}
