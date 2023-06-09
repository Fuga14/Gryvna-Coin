// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./ERC20.sol";
import "./IERC20.sol";

contract GryvnaToken is ERC20 {
    constructor(address shop) ERC20("GryvnaToken", "GT", 100000, shop) {}
}

contract GShop {
    IERC20 public token;
    address payable public owner;

    event Bought(uint _amount, address indexed buyer);
    event Sold(uint _amount, address indexed _seller);

    constructor() {
        token = new GryvnaToken(address(this));
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not an owner!");
        _;
    }

    modifier enoughTokens(address _from, uint _amount) {
        require(token.balanceOf(_from) >= _amount, "Not enough tokens!");
        _;
    }

    function sell(uint _amountToSell) external {
        require(
            _amountToSell > 0 && token.balanceOf(msg.sender) > 0,
            "Incorrect amount of tokens!"
        );

        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "Check allowance!");

        token.transferFrom(address(this), msg.sender, _amountToSell);
        (bool success, ) = payable(msg.sender).call{value: _amountToSell}("");
        require(success, "Transfer amount failed!");

        emit Sold(_amountToSell, msg.sender);
    }

    function getTokenAddress() public view returns (address) {
        return address(token);
    }

    /*
    function withdrawMoney(
        uint amount
    ) public payable enoughTokens(msg.sender, amount) {
        require(
            address(this).balance >= amount,
            "Insufficient balance in the contract"
        );
        token.transfer(address(this), amount);
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
    */

    function tokenBalance() public view returns (uint) {
        return token.balanceOf(address(this));
    }

    receive() external payable {
        uint tokensToBuy = msg.value; // 1 wei = 1 token
        require(tokensToBuy > 0, "not enough funds!");

        require(tokenBalance() >= tokensToBuy, "not enough tokens!");

        token.transfer(msg.sender, tokensToBuy);

        emit Bought(tokensToBuy, msg.sender);
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
