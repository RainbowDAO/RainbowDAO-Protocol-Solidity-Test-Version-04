// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
import './Governor.sol';
import './interface/IProposalFactory.sol';

contract ProposalFactory is IProposalFactory {
    address[] public GovernorDaos;
    function newProposal(address _govToken) external override returns(address) {
        Governor ud = new Governor(_govToken);
        GovernorDaos.push(address(ud));
        return address(ud);
    }
    // get the dao count
    function getProposalDaosLength() public view returns(uint){
        return GovernorDaos.length;
    }
}

