// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
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
}
