// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {SimpleStorage} from "../../src/SimpleStorage.sol";
import {DeploySimpleStorage} from "../../script/DeploySimpleStorage.s.sol";

contract DeploySimpleStorageTest is Test {
    DeploySimpleStorage deployer;

    function setUp() external {
        deployer = new DeploySimpleStorage();
    }

    function testDeploySimpleStorageIsWorkingWell() public {
        SimpleStorage simpleStorage = deployer.run();

        assert(SimpleStorage(payable(address(simpleStorage))) == simpleStorage);
    }
}
