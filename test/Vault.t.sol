// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CrondexVault} from "../src/CrondexVault.sol";
import {SenderStrategy} from "../src/SenderStrategy.sol";
import {ReceiverStrategy} from "../src/ReceiverStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultTest is Test {
    uint256 polygonFork;
    uint256 optimismFork;

    address user1 = address(1);
    address user2 = address(2);

    ReceiverStrategy receiverStrategy;
    CrondexVault vault;
    SenderStrategy senderStrategy;

    function setUp() public {
        //     receiverStrategy = new ReceiverStrategy(address(reaperDaiVault),daiOptimism);
        //     // vm.makePersistent(address(receiverStrategy));
        //     console2.log("receiver strategy address: %s", address(receiverStrategy));

        //     vault = new CrondexVault(daiPolygon,"crondex vault DAI","cvDAI", 0, 1e6 ether); // 1 million cap
        //     senderStrategy =
        //         new SenderStrategy(connextPolygon,address(vault),daiPolygon,address(receiverStrategy),optimismDomainId);

        //     console2.log("sender strategy address: %s", address(senderStrategy));
        //     console2.log("vault address: %s", address(vault));
        //     vault.initialize(address(senderStrategy));
        // }

        // function test_deposit() public {
        //     vm.selectFork(polygonFork);
        //     deal(daiPolygon, user1, 1000e18);
        //     deal(address(senderStrategy), 10 ether);
        //     vm.startPrank(user1);
        //     IERC20(daiPolygon).approve(address(vault), 10e18);

        //     vault.deposit(10e18);
        //     vm.stopPrank();

        //     vm.selectFork(optimismFork);
        //     console2.log("token bal in receiver", receiverStrategy.getTokenBal());
    }
}
