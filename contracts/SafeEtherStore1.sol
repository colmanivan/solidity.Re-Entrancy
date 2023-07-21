// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./IEtherStore.sol";

contract SafeEtherStore1 is IEtherStore
{
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");        
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}