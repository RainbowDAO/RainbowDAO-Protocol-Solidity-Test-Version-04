// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
import './interface/IUnionDao.sol';
import './interface/IDaoManager.sol';
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
contract UnionDao is IUnionDao{
    using EnumerableSet for EnumerableSet.AddressSet;
    address public mainDao;
    string public name;
    EnumerableSet.AddressSet private daos;
    
    constructor(address _mainDao,string memory _name) {
        mainDao = _mainDao;
        name = _name;
    }

    function join() external override{
        require(IDaoManager(msg.sender).unionDao() == address(0),'Already exists unionDao');
        daos.add(msg.sender);
    }

}