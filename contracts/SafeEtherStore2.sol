// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./IEtherStore.sol";

contract SafeEtherStore2 is IEtherStore
{
    bool private locked;
    mapping(address => uint256) public balances;

    modifier noReentrant() 
    {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public noReentrant{
        require(balances[msg.sender] > 0);
        uint256 amount = balances[msg.sender];
        (bool sent, ) = msg.sender.call{value: amount}("");
        balances[msg.sender] = 0;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}