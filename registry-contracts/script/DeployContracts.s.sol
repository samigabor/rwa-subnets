// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";

import {Registry} from "../src/Registry.sol";
import {Lender} from "../src/Lender.sol";
import {HelperConfig} from "./HelperConfig.s.sol";


/** 
@dev Deploy to Anvil (start anvil chain in another terminal by running `anvil`): 
 forge script script/DeployContracts.s.sol \
 --rpc-url http://127.0.0.1:8545 \
 --broadcast \
 --private-key=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
*/
contract DeployContracts is Script {
    address deployer;
    uint256 deployerKey;

    function run() external returns (Registry registry, Lender lender, HelperConfig helperConfig) {
        helperConfig = new HelperConfig();
        (deployer, deployerKey) = helperConfig.config();
        console.log("#DeployContracts.run: deployer=%s, deployerKey=%s, chain id=%s", deployer, deployerKey, block.chainid);
        
        vm.startBroadcast(deployerKey);
        
        registry = deployRegistry();
        lender = deployLender(address(registry));

        vm.stopBroadcast();
    }

    function deployRegistry() private returns (Registry registry) {
        registry = new Registry();
        console.log("Registry deployed at: ", address(registry));
    }

    function deployLender(address registry) private returns (Lender lender) {
        lender = new Lender(registry);
        console.log("Lender deployed at: ", address(lender));
    }
}
