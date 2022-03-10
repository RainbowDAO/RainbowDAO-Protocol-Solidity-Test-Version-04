// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;

contract UnionDao {
    address public mainDao;
    string public name;
    constructor(address _mainDao,string memory _name) {
        mainDao = _mainDao;
        name = _name;
    }
}