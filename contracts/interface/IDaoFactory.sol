// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
interface IDaoFactory {
    function newDao(string memory _name,string memory _desc, string memory _logo,address _govToken, bool _isRainbowToken,address manager,uint _daoType,address _parentDao) external returns(address);
}
