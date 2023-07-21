// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IEtherStore {
  function deposit() external payable;
  function withdraw() external;
  function getBalance() external view returns (uint256);
}