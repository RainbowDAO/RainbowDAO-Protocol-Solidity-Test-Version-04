// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IDepartmentFactory {
    function newDepartment(string memory _name,string memory _logo) external  returns(address);
}
