// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
import './Department.sol';
import './interface/IDepartmentFactory.sol';
contract DepartmentFactory is IDepartmentFactory {
    function newDepartment(string memory _name,string memory _logo) external override returns(address) {
        Department dt = new Department(msg.sender,_name,_logo);
        return address(dt);
    }
}

