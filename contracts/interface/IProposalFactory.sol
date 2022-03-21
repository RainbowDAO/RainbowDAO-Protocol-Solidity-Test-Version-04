// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
interface IProposalFactory {
    function newProposal(address _govToken) external  returns(address);
}
