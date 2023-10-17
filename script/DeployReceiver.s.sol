// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/ReceiverStrategy.sol";
import {console2} from "forge-std/Test.sol";

contract DeployReceiver is Script {
    function run() external returns (address) {
        address TEST = 0x7ea6eA49B0b0Ae9c5db7907d139D9Cd3439862a1;
        address vault = address(0); //Change
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        ReceiverStrategy receiver = new ReceiverStrategy(vault, TEST);
        vm.stopBroadcast();
        console2.log("receiver address: %s", address(receiver));

        return (address(receiver));
    }
}
