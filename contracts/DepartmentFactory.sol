pragma solidity ^0.8.0;
import './Department.sol';
import './interface/IDepartmentFactory.sol';
contract DepartmentFactory is IDepartmentFactory {
    function newDepartment() external override returns(address) {
        Department dt = new Department();
        return address(dt);
    }
}
