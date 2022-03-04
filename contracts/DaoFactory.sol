pragma solidity ^0.8.0;

import './DaoManager.sol';
contract DaoFactory {
    address[] public daos;
    address public router;
    constructor(address _router) public {
        router = _router;
    }
    function newDao(string memory _name,string memory _desc, string memory _logo,address _govToken, bool _isRainbowToken) returns(address) {
        DaoManager dao = new DaoManager(_name,_desc,_logo,_govToken,_isRainbowToken,msg.sender,router);
        daos.push(address(dao));
        return address(dao);
    }
    // Get the dao counts
    function getDaoCount() public view returns(uint) {
        return daos.length();
    }
}
