// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeploySimpleStorage} from "../../script/DeploySimpleStorage.s.sol";
import {SimpleStorage} from "../../src/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage private s_simpleStorage;

    address USER = makeAddr("USER");

    function setUp() external {
        DeploySimpleStorage deployer = new DeploySimpleStorage();
        s_simpleStorage = deployer.run();
    }

    function testStoreNumberFailsIfTryToStoreZero() public {
        vm.prank(USER);
        vm.expectRevert(SimpleStorage.SimpleStorage__MustBeGreaterThanZero.selector);
        s_simpleStorage.storeNumber(0);
    }

    function testCanStoreNumberGreaterThanZero() public {
        uint256 expectedFavoriteNumber = 111;

        vm.prank(USER);
        s_simpleStorage.storeNumber(expectedFavoriteNumber);

        uint256 actualFavoriteNumber = s_simpleStorage.getFavoriteNumber();

        assertEq(actualFavoriteNumber, expectedFavoriteNumber);
    }

    function testCannotStoreFavoriteNumberIfUserNameNotProvided() public {
        vm.prank(USER);
        vm.expectRevert(SimpleStorage.SimpleStorage__NameCannotBeEmpty.selector);
        s_simpleStorage.addPerson("", 123);
    }

    function testCannotStoreZeroAsFavoriteNumber() public {
        vm.prank(USER);
        vm.expectRevert(SimpleStorage.SimpleStorage__MustBeGreaterThanZero.selector);
        s_simpleStorage.addPerson("Anil", 0);
    }

    function testRecordPersonDetailSuccessfully() public {
        string memory expectedName = "Anil";
        uint256 expectedFavoriteNumber = 123;

        vm.prank(USER);
        s_simpleStorage.addPerson(expectedName, expectedFavoriteNumber);
        SimpleStorage.Person memory person = s_simpleStorage.getPersonDetailFromList(0);
        uint256 personFavoriteNumber = s_simpleStorage.getPersonFavoriteNumber(person.name);

        assertEq(keccak256(abi.encodePacked(person.name)), keccak256(abi.encodePacked(expectedName)));
        assertEq(person.favoriteNumber, expectedFavoriteNumber);
        assertEq(personFavoriteNumber, expectedFavoriteNumber);
    }

    function testLowLevelCallsNotAllowedWithoutDataRECEIVE() public {
        vm.prank(USER);
        vm.expectRevert(SimpleStorage.SimpleStorage__InvalidOrNotAllowedCall.selector);
        (bool success,) = address(s_simpleStorage).call("");

        assertEq(success, true);
    }

    function testLowLevelCallsNotAllowedWithDataFALLBACK() public {
        hoax(USER, 2 ether);
        vm.expectRevert(SimpleStorage.SimpleStorage__InvalidOrNotAllowedCall.selector);

        // (bool success,) = address(s_simpleStorage).call{value: 1 ether}(
        //     abi.encodeWithSignature("storeAddress(string)", "House Number: 255")
        // );

        (bool success,) = payable(address(s_simpleStorage)).call{value: 1 ether}(
            abi.encodeWithSignature("storeNumber(uint256)", 2667)
        );

        console.log("is success: ", success);
        console.log("Favorite Number: ", s_simpleStorage.getFavoriteNumber());

        assertEq(success, false);
    }
}
