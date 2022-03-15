// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;
interface IDaoManager {
    function checkUserExists(address _user) external view returns(bool);
    function manager() external view returns(address);
    function existsUnionDao(address _unionDao) external view returns(bool);
    // function unionDao() external view returns(address);
}
