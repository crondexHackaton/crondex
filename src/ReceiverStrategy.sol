// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IXReceiver} from "@connext/interfaces/core/IXReceiver.sol";
import  "./interfaces/IReaper.sol";

/**
 * @title DestinationGreeter
 * @notice Example destination contract that stores a greeting.
 */
contract ReceiverStrategy is IXReceiver {
    string public greeting;

    event amountReceived(uint256 _amount);

    IReaperVault public strategy;
    // The token to be paid on this domain
    IERC20 public immutable token;

    constructor(address _vaultAdress) {
        strategy = IReaperVault(_vaultAdress);
    }


    function deposit(uint256 _amount) public {
        strategy.deposit(_amount, address(this));
    }
    /**
     * @notice The receiver function as required by the IXReceiver interface.
     * @dev The Connext bridge contract will call this function.
     */
    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes memory _callData
    ) external returns (bytes memory) {
        // Check for the right token
        require(_asset == address(token), "Wrong asset received");
        // Enforce a cost to update the greeting
        require(_amount > 0, "Must pay at least 1 wei");

        // Unpack the _callData
        string memory receivedConfirmation = abi.decode(_callData, (string));

        deposit(_amount);
        
        emit amountReceived(_amount);
    }
}
