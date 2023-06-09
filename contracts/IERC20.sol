// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external pure returns (uint); //0

    /**
     * @dev Standart function that require ERC20
     */

    function totalSupply() external view returns (uint); // Сколько токенов есть в обороте| How many tokens?

    function balanceOf(address account) external view returns (uint); // How many tokens are on account

    function transfer(address to, uint amount) external;

    function allowance(
        address _owner,
        address spender
    ) external view returns (uint); // Give permission to spender to take some tokens from owner acc

    function approve(address spender, uint amount) external; // Approve who can take tokens and how much

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external;

    event Transfer(address indexed from, address indexed to, uint amount);

    event Approve(address indexed owner, address indexed to, uint amount);
}
