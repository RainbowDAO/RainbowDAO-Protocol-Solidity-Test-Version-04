pragma solidity ^0.8.0;
contract DaoVault {
    address public dao;
    constructor(address _dao) public {
        dao = _dao;
    }
}