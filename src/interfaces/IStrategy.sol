// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

interface IStrategy {
    //deposits all funds into the farm
    function xSendToken(uint256, address) external payable;

    //vault only - withdraws funds from the strategy
    function withdraw(uint256 _amount, address _user,uint256, uint256) external payable;

    //claims rewards, charges fees, and re-deposits; returns caller fee amount.
    function harvest() external returns (uint256);

    //returns the balance of all tokens managed by the strategy
    function balanceOf() external view returns (uint256);

    //pauses deposits, resets allowances, and withdraws all funds from farm
    function panic() external;

    //pauses deposits and resets allowances
    function pause() external;

    //unpauses deposits and maxes out allowances again
    function unpause() external;
}
