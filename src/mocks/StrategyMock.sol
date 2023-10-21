// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IReaperVault} from "../interfaces/IReaperVault.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IERC20Extented is IERC20 {
    function decimals() external view returns (uint8);
}

contract StrategyMock is Ownable {
    using SafeERC20 for IERC20Extented;

    address public vault;

    // tokens used
    address public want;
    address public loanToken;
    address public aToken;
    // Aave contracts
    address public lendingPool;
    address public dataProvider;
    address public aaveIncentives;
    address public priceOracle;
    //Reaper contracts
    address public reaperVault;

    //Contants
    uint256 public constant PRECISION = 100;
    uint256 public constant LIQUIDATION_TRESHOLD = 50;
    uint256 FEED_PRECISION = 1e10;
    uint256 MIN_HEALTH_FACTOR = 1500000000000000000;
    uint256 PERCENTAGE_BPS = 10000;
    uint256 REAPER_FEE_BPS = 1000;

    constructor(address _vault, address _want) Ownable(msg.sender) {
        vault = _vault;
        want = _want;
    }

    function deposit() external {
        require(msg.sender == vault, "!vault");
    }

    /**
     * @dev Withdraws funds and sends them back to the vault.
     */
    function withdraw(uint256 _amount) external {
        require(msg.sender == vault, "!vault");
        uint256 currBal = balanceOf();
        IERC20Extented(want).safeTransfer(vault, _amount);
    }
    /* --------------------------- INTERNAL FUNCTIONS --------------------------- */

    /* ----------------------------- VIEW FUNCTIONS INTERNAL ----------------------------- */
    // return supply and borrow balance

    function _balanceOfWant() internal view returns (uint256) {
        return IERC20Extented(want).balanceOf(address(this));
    }

    function _earned() internal view returns (uint256) {
        return 0;
        // Normalize to 8 decimals
    }

    /* ------------------------------- PUBLIC VIEW FUNCTIONS ------------------------------ */

    function balanceOf() public view returns (uint256) {
        return _balanceOfWant() + _earned();
    }
}
