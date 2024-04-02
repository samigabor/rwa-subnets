// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";

contract HelperConfig is Script {
    struct Config {
        address deployer;
        uint256 deployerKey;
    }

    Config public config;

    constructor() {
        if (block.chainid == 31337) {
            config = Config({
                deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
                deployerKey: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
            });
            console.log("Anvil config: deployer=%s, deployerKey=%s", config.deployer, config.deployerKey);
        } else {
            config = Config({
                deployer: vm.envAddress("VALIDATOR"),
                deployerKey: vm.envUint("VALIDATOR_KEY")
            });
            console.log("Subnet config: deployer=%s, deployerKey=%s", config.deployer, config.deployerKey);
        }
    }
}
