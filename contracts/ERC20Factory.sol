// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
import './erc20.sol';
contract ERC20Factory {
    function newToken(address _manager,uint _totalSupply,string memory _name,string memory _symbol,bool _isMint) public returns(address) {
        erc20 govToken = new erc20(_manager,_totalSupply,_name,_symbol,_isMint);
        return address(govToken);
    }
}

