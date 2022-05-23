// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;

interface IChainLinkOracle {
    function calculatePrice(uint fee) external view returns(uint);
}
