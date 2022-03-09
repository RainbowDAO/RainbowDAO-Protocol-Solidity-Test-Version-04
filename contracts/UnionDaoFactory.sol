pragma solidity ^0.8.0;
import './UnionDao.sol';
import './interface/IUnionDaoFactory.sol';
contract UnionDaoFactory is IUnionDaoFactory {
    function newUnionDao() external override returns(address) {
        UnionDao ud = new UnionDao(msg.sender);
        return address(ud);
    }
}
