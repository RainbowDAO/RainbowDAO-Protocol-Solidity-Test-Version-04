// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;

import './interface/IContractRegister.sol';

contract ContractRegister is IContractRegister {
    mapping (string => address) public override routers;
    address public manager;
    constructor(){
        manager = msg.sender;
    }

    // set the route name and address
    function SaveContract(string memory _name,address _address ) external override {
        require(msg.sender == manager, 'no access');
        routers[_name] = _address;
    }
}
