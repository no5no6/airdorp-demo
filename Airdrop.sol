pragma solidity ^0.8.18;

import {IAirdrop} from './interface/IAirDrop.sol';
import {IERC20} from "./interface/IERC20.sol";

contract Airdrop is IAirdrop {
  error Airdrop__multiSendToken_LengthNotEqual();
  error Airdrop__multiSendToken_AllowanceIsNotEnough();
  error Airdrop__multiSendToken_PaymentFailed();
  error Airdrop__withdraw_PaymentFailed();

  mapping(address user => uint256 _amount) private failureMap;

  constructor() {
  }

  modifier onlyLengthEhEqual(address[] memory _users, uint256[] memory _amounts) {
    if(_users.length != _amounts.length) {
      revert Airdrop__multiSendToken_LengthNotEqual();
    }

    _i;
  }

  function multiSendToken(address _token, address[] memory _users, uint256[] memory _amounts) public override onlyLengthEhEqual(_users, _amounts){
    // if(_uers.length != _amounts.length) {
    //   return ();
    // }
    
    // require(_user.length == _amounts.length, 'xxxxxxxxxxxxxx')  // gas 消耗大，改成下方 revert 方式

    // if(_users.length != _amounts.length) {
    //   revert Airdrop_multiSendToken_LengthNotEqual();
    // }

    IERC20 token = IERC20(_token);
    // require(token.allowance(msg.sender, address(this) >= calculateSum(_amounts))) // gas 消耗大，改成下方 revert 方式

    if(token.allowance(msg.sender, address(this) < calculateSum(_amounts))) {  
      revert Airdrop__multiSendToken_AllowanceIsNotEnough();
    }
    
    // uint256 i = 0 类似这个操作 gas 消耗很大，建议这么写  for(uint256 i; i < _users.length; i++)
    for(uint256 i = 0; i < _users.length; i++) {
      token.transferFrom(msg.sender, _users[i], _amounts[i]);
    }
  }

  function multiSendEth(address[] memory _users, uint256[] memory _amounts) public override onlyLengthEhEqual(_users, _amounts){
    for (uint256 i; i< _users.length; i++) {
      (bool _success,) = _users[i].call{value: _amounts[i]}("");
      if(!_success) {
        failureMap[_users[i]] = _amounts[i]
      }
    }
  }

  function withdraw(address _user) public override returns (bool _isSuccess){
    uint256 _amount = failureMap[_user];
    failureMap[_user] = 0;
    (_isSuccess,) = _user.call{value: _amount}("");

    if(!_isSuccess) {
      revert Airdrop__withdraw_PaymentFailed();
    }
  }

  function calculateSum(uint256[] memory _amounts) internal pure override returns (uint256 _total) {
    for(uint256 i; i < _amounts.length; i++) {
      _total += _amounts[i];
    }
  }

}