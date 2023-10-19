// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {console2} from "forge-std/Test.sol";
import {CrondexVault} from "../src/CrondexVault.sol";
import {TestHelper} from "./TestHelper.sol";
import {SenderStrategy} from "../src/SenderStrategy.sol";
import {StrategyHandler} from "../src/StrategyHandler.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IReaperVault} from "../src/interfaces/IReaperVault.sol";

contract VaultTest is TestHelper {
    address public immutable OP_USDC = 0x7F5c764cBc14f9669B88837ca1490cCa17c31607;
    address public immutable ARB_USDC = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;

    address public reaperUsdcVault = 0xaD17A225074191d5c8a37B50FdA1AE278a2EE6A2;
    // address public immutable reaperUsdcVault = 0x508734b52BA7e04Ba068A2D4f67720Ac1f63dF47;
    address user1 = address(1);
    address user2 = address(2);

    StrategyHandler handler;
    CrondexVault vault;
    SenderStrategy senderStrategy;

    function utils_setUpOrigin() public {
        setUpArbitrum(78000226);
        vault = new CrondexVault(ARB_USDC,"crondex vault ARB","cvARB",0,1e6 * 1e6); //6 decimals
        senderStrategy =
            new SenderStrategy(CONNEXT_ARBITRUM, address(vault),ARB_USDC,address(handler),OPTIMISM_DOMAIN_ID);
        vault.initialize(address(senderStrategy));

        deal(ARB_USDC, address(this), 100e6);
        deal(address(this), 10 ether);
    }

    function utils_setUpDestination() public {
        setUpOptimism(87307161);
        // console2.log("code length", address(reaperUsdcVault).code.length);
        handler = new StrategyHandler(reaperUsdcVault,OP_USDC,CONNEXT_OPTIMISM,ARBITRUM_DOMAIN_ID);
        vm.makePersistent(address(reaperUsdcVault));
    }

    function test_deposit() public {
        utils_setUpDestination();
        utils_setUpOrigin();

        vm.selectFork(arbitrumForkId);
        assertEq(vm.activeFork(), arbitrumForkId);
        IERC20(ARB_USDC).approve(address(vault), 100e6); //
        vault.deposit{value: 0.03 ether}(100e6, 0.03 ether);

        //sending 10 token
        vm.selectFork(optimismForkId);
        assertEq(vm.activeFork(), optimismForkId);
        handler.initSource(address(vault));
        deal(OP_USDC, address(handler), 100e6);
        vm.prank(CONNEXT_OPTIMISM);
        bytes memory _callData = abi.encode(true, address(this), 0, 0);

        handler.xReceive(bytes32(""), 100e6, OP_USDC, address(0), 123, _callData);
        assertEq(IERC20(reaperUsdcVault).balanceOf(address(handler)), 99468278);
    }

    // function test_reaperDeposit() public {
    //     utils_setUpDestination();
    //     vm.selectFork(optimismForkId);
    //     deal(OP_USDC, address(this), 100e6);
    //     IReaperVault(0x794a61358D6845594F94dc1DB02A252b5b4814aD).deposit(OP_USDC, 100e6, address(this), 0);
    // }
}
