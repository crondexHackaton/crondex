// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IConnext} from "@connext/interfaces/core/IConnext.sol";

/**
 * @title Strategy
 * @notice source contract that send token to another chain.
 */
contract Strategy {
    // The Connext contract on this domain
    IConnext public immutable connext;
    // Slippage (in BPS) for the transfer set to 100% for this example
    uint256 immutable slippage = 10000;
    uint256 immutable relayerFee = 30000000000000000;

    address public vault;
    IERC20 public want; // token to deposit or to maximize
    address receiverContract;
    uint32 destinationDomain;

    constructor(address _connext, address _vault, address _want, address _receiverContract, uint32 _destinationDomain) {
        connext = IConnext(_connext);
        vault = _vault;
        want = IERC20(_want);
        receiverContract = _receiverContract;
        destinationDomain = _destinationDomain;
    }

    function deposit() external {
        require(msg.sender == vault, "Only the vault can call this");
        // Do xCall to deposit funds into receiver contracts
        // xSendToken(balanceOfWant());
    }

    function xSendToken(uint256 amount) public payable {
        require(msg.sender == vault, "Only the vault can call this");
        require(want.allowance(msg.sender, address(this)) >= amount, "User must approve amount");
        // This contract approves transfer to Connext
        want.approve(address(connext), amount);

        connext.xcall{value: relayerFee}(
            destinationDomain, receiverContract, address(want), msg.sender, amount, slippage, bytes("")
        );
    }

    /**
     * @dev total want the strategy is managing.
     */
    function balanceOfWant() internal view returns (uint256) {
        return IERC20(want).balanceOf(address(this));
    }

    function balanceOf() external view returns (uint256) {
        return balanceOfWant(); //TODO:will also account for want in destination chain.
    }
}
