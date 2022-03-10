// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
import './UnionDao.sol';
import './interface/IUnionDaoFactory.sol';

contract UnionDaoFactory is IUnionDaoFactory {
    address[] public unionDaos;
    function newUnionDao(string memory _name) external override returns(address) {
        UnionDao ud = new UnionDao(msg.sender,_name);
        unionDaos.push(address(ud));
        return address(ud);
    }
    // get the dao count
    function getUnionDaoLength() public view returns(uint){
        return unionDaos.length;
    }
}
