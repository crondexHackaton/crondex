// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console2} from "forge-std/Test.sol";
import {CrondexVault} from "../src/CrondexVault.sol";
import {TestHelper} from "./TestHelper.sol";
import {SenderStrategy} from "../src/SenderStrategy.sol";
import {ReceiverStrategy} from "../src/ReceiverStrategy.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VaultTest is TestHelper {
    address public immutable OP_OP = 0x4200000000000000000000000000000000000042;
    address public immutable OP_USDC = 0x7F5c764cBc14f9669B88837ca1490cCa17c31607;
    address public immutable ARB_USDC = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;
    address public immutable ARB_ARB = 0x912CE59144191C1204E64559FE8253a0e49E6548;

    address user1 = address(1);
    address user2 = address(2);

    ReceiverStrategy receiverStrategy;
    CrondexVault vault;
    SenderStrategy senderStrategy;

    function utils_setUpOrigin() public {
        setUpOptimism(87307161);
        vault = new CrondexVault(OP_USDC,"crondex vault OP","cvOP",0,1e6 ether);
        senderStrategy =
            new SenderStrategy(CONNEXT_OPTIMISM, address(vault),OP_USDC,address(receiverStrategy),ARBITRUM_DOMAIN_ID);
        vault.initialize(address(senderStrategy));
        deal(OP_USDC, address(this), 1e6 ether);
        deal(address(this), 10 ether);
    }

    function utils_setUpDestination() public {
        setUpArbitrum(78000226);
        receiverStrategy = new ReceiverStrategy(address(0),ARB_USDC);
    }

    function test_deposit() public {
        utils_setUpDestination();
        utils_setUpOrigin();
        vm.selectFork(optimismForkId);
        assertEq(vm.activeFork(), optimismForkId);
        IERC20(OP_USDC).approve(address(vault), 10 ether); //
        console2.log("Balance of caller", address(this).balance);
        vault.deposit{value: 0.03 ether}(10 ether, 0.03 ether);
        //sending 10 token

        vm.selectFork(arbitrumForkId);
        deal(ARB_USDC, address(receiverStrategy), 100 ether);
        // deal(ARB_USDC, CONNEXT_ARBITRUM, 10 ether);
        vm.prank(CONNEXT_ARBITRUM);
        receiverStrategy.xReceive(bytes32(""), 10 ether, ARB_USDC, address(0), 123, bytes(""));
        // assertEq(receiverStrategy.greeting(), "New Greeting");
        assertEq(IERC20(ARB_USDC).balanceOf(address(receiverStrategy)), 10 ether);
    }
}
