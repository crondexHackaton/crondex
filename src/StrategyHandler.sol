// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./interfaces/IReaper.sol";
import "./interfaces/IStrategy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {console2} from "forge-std/console2.sol";
import {IXReceiver} from "@connext/interfaces/core/IXReceiver.sol";

import {IConnext} from "@connext/interfaces/core/IConnext.sol";

/**
 * @dev Implementation of a vault to deposit funds for yield optimizing.
 * This is the contract that receives funds and that users interface with.
 * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
 */
contract StrageyHandler is IXReceiver {
    using SafeERC20 for IERC20;

    // The strategy in use by the vault.
    IReaperVault public reaperVault;
    IERC20 public token;
    address senderStrat;
    IConnext public connext;
    uint32 public destinationDomain;
    uint256 public slippage = 10000;

    /**
     * @dev Initializes the  Reaper strategy handler
     * @param _repearVault reaper vault on optimism.
     * @param _sender the sender contract.
     * @param _token the sender contract.
     */
    constructor(address _repearVault, address _sender, address _token, address _connext, uint32 _destinationDomain) {
        reaperVault = IReaperVault(_repearVault);
        senderStrat = _sender;
        token = IERC20(_token);
        connext = IConnext(_connext);
        destinationDomain = _destinationDomain;
    }

    function withdraw(uint256 amount, uint256 relayerFee, address signer) public {
        require(relayerFee != 0, "please provide relayer fee");
        require(amount != 0, "please provide amount");
        uint256 _pool = totalAmount();
        require(_pool - amount >= 0, "not enough funds");

        reaperVault.withdraw(amount, address(this), address(reaperVault));
        uint256 _after = totalAmount();
        uint256 _amount = _pool - _after;

        // IStrategy(senderStrat).xSendToken{value: relayerFee}(relayerFee, signer);
    }

    function totalAmount() public view returns (uint256) {
        return reaperVault.balanceOf(address(this));
    }

    event amountReceived(uint256 _amount);

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

        console2.log("amount received: %s", _amount);
        // vault.deposit(_amount, address(this)); // deposit to reaper

        emit amountReceived(_amount);

        (bool deposit, address signer, uint256 amount, uint256 relayerfee) =
            abi.decode(_callData, (bool, address, uint256, uint256));

        if (deposit) {
            reaperVault.deposit(_amount, address(this));
        } else {
            withdraw(amount, relayerfee, signer);
        }
    }

    function getTokenBal() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function _xSendCompondedTokens(uint256 relayerFee, uint256 amount, address _target) internal {
        connext.xcall{value: relayerFee}(
            destinationDomain, // _destination: Domain ID of the destination chain
            senderStrat, // _to: address of the target contract
            address(token), // _asset: address of the token contract
            msg.sender, // _delegate: address that can revert or forceLocal on destination
            amount, // _amount: amount of tokens to transfer
            slippage, // _slippage: max slippage the user will accept in BPS (e.g. 300 = 3%)
            bytes("") // _callData: the encoded calldata to send
        );
    }
}
