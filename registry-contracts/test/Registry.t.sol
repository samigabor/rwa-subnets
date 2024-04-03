// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployContracts} from "../script/DeployContracts.s.sol";
import {Registry} from "../src/Registry.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

/**
 * forge test --fork-url $RPC_URL
 */
contract CommunityRegistryTest is Test {
    Registry registry;
    HelperConfig helperConfig;

    address public deployer;
    address public from;
    address public to;

    function setUp() public {
        DeployContracts deployScript = new DeployContracts();
        (registry, /** lender */, helperConfig) = deployScript.run();
        (deployer, ) = helperConfig.config();
        from = makeAddr("user1");
        to = makeAddr("user2");
    }

    function testCreateAsset() public {
        uint256 assetId = 100;

        vm.prank(deployer);
        uint256 tokenId = registry.createAsset(from, "user1", assetId);

        assertEq(registry.ownerOf(tokenId), from);
    }

    function testTransferAsset() public {
        uint256 assetId = 100;
        vm.prank(deployer);
        uint256 tokenId = registry.createAsset(from, "user1", assetId);

        vm.prank(from);
        registry.transferAsset(tokenId, to, "user2");

        assertEq(registry.ownerOf(tokenId), to);
    }

    function testVerifyRequest() public {
        uint256 assetId = 100;

        vm.prank(deployer);
        registry.createAsset(from, "user1", assetId);

        assertEq(registry.verifyRequest(from, 100), true);
    }
}
