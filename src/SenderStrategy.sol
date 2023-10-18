// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IConnext} from "@connext/interfaces/core/IConnext.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console2} from "forge-std/Test.sol";

/**
 * @title SourceGreeter
 * @notice Example source contract that updates a greeting on DestinationGreeter.
 */
contract SenderStrategy {
    // The Connext contract on this domain
    IConnext public immutable connext;

    // The token to be paid on this domain
    IERC20 public immutable token;

    // Slippage (in BPS) for the transfer set to 100% for this example
    uint256 public immutable slippage = 10000;

    uint32 public destinationDomain;

    address public receiverContract;

    address public crondexVault;

    constructor(address _connext, address _crondexVault, address _token, address _receiver, uint32 _destinationDomain) {
        connext = IConnext(_connext);
        token = IERC20(_token);
        destinationDomain = _destinationDomain;
        receiverContract = _receiver;
        crondexVault = _crondexVault;
    }

    function xSendToken(uint256 relayerFee, address signer, uint256 amount) external payable {
        console2.log("Who is msg.sender", msg.sender);
        
        // This contract approves transfer to Connext
        token.approve(address(connext), amount);

        // Encode calldata for the target contract call

        bytes memory _callData = abi.encode(true, signer, 0, 0);
        connext.xcall{value: relayerFee}(
            destinationDomain, // _destination: Domain ID of the destination chain
            receiverContract, // _to: address of the target contract
            address(token), // _asset: address of the token contract
            msg.sender, // _delegate: address that can revert or forceLocal on destination
            amount, // _amount: amount of tokens to transfer
            slippage, // _abislippage: max slippage the user will accept in BPS (e.g. 300 = 3%)
            bytes(_callData) // _callData: the encoded calldata to send
        );
    }

    function withdraw(uint256 amount, address sender, uint256 relayerFee, uint256 relayerFeeP) external payable {
        console2.log("Who is msg.sender", msg.sender);
        
        // This contract approves transfer to Connext
        token.approve(address(connext), 0);

        // Encode calldata for the target contract call
        bytes memory _callData = abi.encode(false, sender, amount, relayerFeeP);
        connext.xcall{value: relayerFee}(
            destinationDomain, // _destination: Domain ID of the destination chain
            receiverContract, // _to: address of the target contract
            address(token), // _asset: address of the token contract
            msg.sender, // _delegate: address that can revert or forceLocal on destination
            0, // _amount: amount of tokens to transfer
            slippage, // _slippage: max slippage the user will accept in BPS (e.g. 300 = 3%)
            bytes(_callData) // _callData: the encoded calldata to send
        );
    }

    function balanceOf() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
