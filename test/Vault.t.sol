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

    address weth = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    address wethOp = 0x4200000000000000000000000000000000000006;
    address connextPolygon = 0x11984dc4465481512eb5b777E44061C158CF2259;
    uint32 polygonDomainId = 1886350457;

    ReceiverStrategy receiverStrategy;
    CrondexVault vault;
    SenderStrategy senderStrategy;

    function setUp() public {
        optimismFork = vm.createFork(vm.envString("OPTIMISM_RPC_URL"));
        polygonFork = vm.createFork(vm.envString("POLYGON_RPC_URL"));
        vm.selectFork(optimismFork);
        assertEq(vm.activeFork(), optimismFork);
        receiverStrategy = new ReceiverStrategy(address(vault),wethOp);
        // vm.makePersistent(address(receiverStrategy));
        console2.log("receiver strategy address: %s", address(receiverStrategy));

        vm.selectFork(polygonFork);
        assertEq(vm.activeFork(), polygonFork);
        vault = new CrondexVault(weth,"crondex vault WBTCJ","cvWETH", 0, 1e6 ether); // 1 million cap
        senderStrategy =
            new SenderStrategy(connextPolygon,address(vault),weth,address(receiverStrategy),polygonDomainId);

        console2.log("sender strategy address: %s", address(senderStrategy));
        console2.log("vault address: %s", address(vault));
        vault.initialize(address(senderStrategy));
    }

    function test_deposit() public {
        vm.selectFork(polygonFork);
        deal(weth, user1, 1000e18);
        deal(address(senderStrategy), 10 ether);
        vm.startPrank(user1);
        IERC20(weth).approve(address(vault), 1000e18);
        vault.deposit(1000e18);
        vm.stopPrank();
    }
}
