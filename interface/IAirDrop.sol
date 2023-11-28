// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IAirdrop {
  function calculateSum(uint256[] memory _amounts) external pure returns (uint256 _total);
  function multiSendToken(address _token, address[] memory _users, uint256[] memory _amounts) external; // 批量发送 token
  function multiSendEth(address[] memory _users, uint256[] memory _amounts) external; // 批量发送 eth
  function withdraw(address _user) external returns (bool _isSuccess);
}
