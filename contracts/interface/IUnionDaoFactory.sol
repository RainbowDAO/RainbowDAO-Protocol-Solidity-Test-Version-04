// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
interface IUnionDaoFactory {
    function newUnionDao(string memory _name) external  returns(address);
}
