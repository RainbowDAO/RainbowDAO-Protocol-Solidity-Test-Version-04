pragma solidity ^0.8.0;

import './DaoVault.sol';
import './interface/IDaoVaultFactory.sol';
contract DaoVaultFactory is IDaoVaultFactory {
    function newVault() public override returns(address){
        DaoVault dv = new DaoVault(msg.sender);
        return address(dv);
    }

}