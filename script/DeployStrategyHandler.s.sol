// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/StrategyHandler.sol";
import {ReaperMock} from "../src/mocks/ReaperMock.sol";
import {StrategyMock} from "../src/mocks/StrategyMock.sol";
import {console2} from "forge-std/Test.sol";

contract DeployStrategyHandler is Script {
    function run() external returns (address) {
        address TEST = 0x7ea6eA49B0b0Ae9c5db7907d139D9Cd3439862a1;
        address connextOp = 0x5Ea1bb242326044699C3d81341c5f535d5Af1504;

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        uint32 desDomain = 1735353714; //goerli
        vm.startBroadcast(deployerKey);
        ReaperMock reaper = new ReaperMock(TEST, "reaper", "reaper", 1 weeks);
        StrategyMock strategy = new StrategyMock(address(reaper),TEST);
        reaper.initialize(address(strategy));
        StrategyHandler handler = new StrategyHandler(address(reaper), TEST,connextOp,desDomain);

        // give some fund to handler for fees
        //   deal(address(handler), 10 ether);
        vm.stopBroadcast();
        console2.log("receiver address: %s", address(handler));

        return (address(handler));
    }
}
