// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;

library PublicStruct {
    // the info of join limit one
    struct JoinLimitOne {
        address token;
        uint allBlock;
        uint tokenAmount;

    }
    struct JoinLimitTwo {
        address token;
        uint holderAmount;
    }
}
