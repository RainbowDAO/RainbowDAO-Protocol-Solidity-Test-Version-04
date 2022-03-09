pragma solidity ^0.8.0;

contract UnionDao {
    address public mainDao;
    constructor(address _mainDao) {
        mainDao = _mainDao;
    }
}