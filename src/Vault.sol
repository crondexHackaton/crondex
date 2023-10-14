// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IStrategy} from "./interfaces/IStrategy.sol";
/**
 * @title Vault
 * @dev Simple EIP4626 vault that mints cvETH tokens upon deposit.
 * @notice we will not charge any fee for deposit and withdrawal
 */

contract Vault is ERC4626, Ownable {
    address public strategy;

    constructor(IERC20 _asset) ERC4626(_asset) ERC20("crondex vault ETH", "cvETH") Ownable(msg.sender) {
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }

    function initialize(address _strategy) external onlyOwner {
        strategy = _strategy;
    }

    /* ---------------------------- INTERNAL OVERRIDE --------------------------- */

    /**
     * @dev Internal conversion function (from assets to shares) with support for rounding direction.
     */
    function _convertToShares(uint256 assets, Math.Rounding rounding) internal view virtual returns (uint256) {
        return assets.mulDiv(totalSupply() + 10 ** _decimalsOffset(), totalAssets() + 1, rounding);
    }

    /**
     * @dev Internal conversion function (from shares to assets) with support for rounding direction.
     */
    function _convertToAssets(uint256 shares, Math.Rounding rounding) internal view virtual returns (uint256) {
        return shares.mulDiv(totalAssets() + 1, totalSupply() + 10 ** _decimalsOffset(), rounding);
    }

    /* ---------------------------- PUBLIC OVERRIDES ---------------------------- */

    /**
     * @dev Returns the total amount of assets (ETH) deposited in the vault and strategy.
     */
    function totalAssets() public view virtual override returns (uint256) {
        return _asset.balanceOf(address(this)) + IStrategy(strategy).balanceOf();
    }

    /**
     * @dev accept asset deposit
     * @dev Returns the amount of shares minted.
     */
    function deposit(uint256 assets, address receiver) public virtual override returns (uint256) {
        uint256 maxAssets = maxDeposit(receiver);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxDeposit(receiver, assets, maxAssets);
        }

        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), receiver, assets, shares);
        _afterDepsit(assets); // call strategy to do something
        return shares;
    }

    /**
     * @dev Returns the amount of assets that for the user.
     */
    function withdraw(uint256 assets, address receiver, address owner) public virtual override returns (uint256) {
        uint256 maxAssets = maxWithdraw(owner);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxWithdraw(owner, assets, maxAssets);
        }

        uint256 shares = previewWithdraw(assets);
        _beforeWithdraw(assets, shares); // call strategy to do something
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return shares;
    }

    /* ------------------ HOOKS TO HANDLE STRATEGY INTEREATIONS ----------------- */
    function _afterDepsit(uint256 assets) internal {
        // IStrategy(strategy).deposit(assets);
    }

    function _beforeWithdraw(uint256 assets, uint256 shares) internal {
        // IStrategy(strategy).withdraw(assets);
    }
}
