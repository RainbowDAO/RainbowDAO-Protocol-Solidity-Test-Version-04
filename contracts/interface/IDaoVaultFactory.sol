// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
interface IDaoVaultFactory {
    function newVault() external  returns(address);
}
