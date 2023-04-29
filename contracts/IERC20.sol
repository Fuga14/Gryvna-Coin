// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external pure returns (uint); //0

    function totalSupply() external view returns (uint); // Сколько токенов есть в обороте| How many tokens?

    function balanceOf(address account) external view returns (uint); // How many tokens are on account

    function transfer(address to, uint amount) external;

    function allowance(
        address owner,
        address spender
    ) external view returns (uint); // Give permission to spender to take some tokens from owner acc

    function approve(address spender, uint amount) external; // Approve who can take tokens and how much
}
