// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;

contract Governor {
    address govToken;
    constructor(address _govToken) {
        govToken = _govToken;
    }

}