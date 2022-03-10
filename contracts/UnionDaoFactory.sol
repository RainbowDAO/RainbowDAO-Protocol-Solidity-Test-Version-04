// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
import './UnionDao.sol';
import './interface/IUnionDaoFactory.sol';
contract UnionDaoFactory is IUnionDaoFactory {
    function newUnionDao(string memory _name) external override returns(address) {
        UnionDao ud = new UnionDao(msg.sender,_name);
        return address(ud);
    }
}
