// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SimpleVault{

mapping( address => uint256 ) public balances;

function deposit() external payable{
    balances[msg.sender]+= msg.value;
}

function withdrawl() external {
    uint256 amount = balances[msg.sender];
    require(amount>0, "No balance");
    (bool success, )=msg.sender.call{value: amount}("");
    require(success, "Transfer Failed");
    balances[msg.sender]=0;
}


}