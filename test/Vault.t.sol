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
    address connextPolygon = 0x11984dc4465481512eb5b777E44061C158CF2259;
    uint32 polygonDomainId = 1886350457;

    ReceiverStrategy receiverStrategy;
    CrondexVault vault;
    SenderStrategy senderStrategy;

    function setUp() public {
        // optimismFork = vm.createFork(vm.envString("OPTIMISM_RPC_URL"));
        // vm.selectFork(optimismFork);
        // TODO: Deploy reeiver to optimism

        polygonFork = vm.createFork(vm.envString("POLYGON_RPC_URL"));
        vm.selectFork(polygonFork);

        vault = new CrondexVault(weth,"crondex vault WBTCJ","cvWETH", 0, 1e6 ether); // 1 million cap
        senderStrategy =
            new SenderStrategy(connextPolygon,address(vault),weth,address(receiverStrategy),polygonDomainId);
    }

    modifier fundUsers() {
        deal(weth, user1, 1000e18);
        deal(weth, user2, 1000e18);
        _;
    }

    modifier fork(uint256 id) {
        if (id == 1) {
            vm.selectFork(polygonFork);
        } else if (id == 2) {
            vm.selectFork(optimismFork);
        } else {
            revert("invalid fork");
        }
        _;
    }

    function test_deposit() public fundUsers {
        vm.startPrank(user1);
        uint256 amount = 10e18;
        IERC20(weth).approve(address(vault), amount);
        console2.log(address(vault));
        // vm.makePersistent(address(vault));
        vault.deposit(amount);
        vm.stopPrank();
    }
}
