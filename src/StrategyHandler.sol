// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./interfaces/IStrategy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {console2} from "forge-std/console2.sol";

/**
 * @dev Implementation of a vault to deposit funds for yield optimizing.
 * This is the contract that receives funds and that users interface with.
 * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
 */
contract CrondexVault is ERC20, Ownable, ReentrancyGuard, IXReceiver {
    using SafeERC20 for IERC20;

    // The strategy in use by the vault.
    IReaperVault public reaperVault;
    IERC20 public token;
    ReceiverStrategy internal receiverStrat;
    SenderStrategy internal senderStrat;


    /**
     * @dev Initializes the  Reaper strategy handler
     * @param _repearVault the name of the reaper vault on optimism.
     * @param _receiver the receiver contract.
     * @param _sender the sender contract.
      * @param _token the sender contract.
     */
    constructor(address _repearVault, address _receiver, uint32 _sender, address _token) {
        reaperVault = IReaperVault(_repearVault);
        receiverContract = ReceiverStrategy(_receiver);
        senderStrat = SenderStrategy(_sender);
        token = IERC20(_token);
    }

    function withdraw(uint256 amount, uint256 relayerFee) external (){
        require(relayerFee != 0, "please provide relayer fee");
        require(_amount != 0, "please provide amount");
        uint256 _pool = totalAmount();
        require(_pool - _amount >= 0, "not enough funds");


        _shares = reaperVault.withdraw(amount, address(this), address(reaperVault))
        uint256 _after = totalAmount();
        _amount = _poll - _after;

        senderStrat.xSendToken{value: relayerFee}(relayerFee);
    }

    function totalAmount() public view {
        return reaperVault.balanceOf(address(this))
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
        greeting = "New greeting";
        emit amountReceived(_amount);

        reaperVault.deposit(_amount, address(this))
    }

    function getTokenBal() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
