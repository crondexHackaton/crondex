// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

import "../src/SenderStrategy.sol";
import "../src/CrondexVault.sol";
import {console2} from "forge-std/Test.sol";

contract DeploySender is Script {
    function run() external returns (address, address) {
        address TEST = 0x7ea6eA49B0b0Ae9c5db7907d139D9Cd3439862a1;
        address connext_goerli = 0xFCa08024A6D4bCc87275b1E4A1E22B71fAD7f649;
        address handler = 0x883f43a32ad5226072B0E0E6ec8FE617fD93Ad7a; //update
        uint32 destDomain = 1735356532;
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        CrondexVault crondexVault = new CrondexVault(TEST,"crondex vault DAI", "cvDAI", 0, 1e6 ether);
        SenderStrategy senderStrategy =
            new SenderStrategy(connext_goerli,address(crondexVault), TEST,handler, destDomain);

        crondexVault.initialize(address(senderStrategy));
        vm.stopBroadcast();

        console2.log("vault address: %s", address(crondexVault));
        console2.log("sender address: %s", address(senderStrategy));
        return (address(crondexVault), address(senderStrategy));
    }
}
