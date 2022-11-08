// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './interface/IDaoManager.sol';
import './interface/IDepartment.sol';
import './lib/TransferHelper.sol';
contract Department is IDepartment{
    using EnumerableSet for EnumerableSet.AddressSet;

    //Address of the Dao to which it belongs
    address public dao;
    EnumerableSet.AddressSet private users;
    EnumerableSet.AddressSet private verifyUsers;
    // the manager of group
    address public manager;
    // Enable join validation
    bool public joinVerify;
    bool public dismissStatus;

    //todo  this group's token
    address public token;
    struct DepartmentBase{
        string  name;
        string  logo;
    }
    DepartmentBase public departmentBaseInfo;

    constructor(address _dao,string memory _name,string memory _logo){
        dao = _dao;
        departmentBaseInfo = DepartmentBase({
            name:_name,
            logo:_logo
        });
    }

    modifier  _isOwner() {
        require(msg.sender == manager);
        _;
    }
    modifier  _isOpen() {
        require(dismissStatus == false ,'the group is close');
        _;
    }

    // join this group
    function joinGroup() public _isOpen {
        require(IDaoManager(dao).checkUserExists(msg.sender) == true ,'not in this dao');
        if(joinVerify){
            require(verifyUsers.contains(msg.sender) == false,'Already joined');
            verifyUsers.add(msg.sender);
        }else{
            require(users.contains(msg.sender) == false,'Already joined');
            users.add(msg.sender);
        }
    }
    //leave this group
    function leaveGroup() public  {
        users.remove(msg.sender);
    }

    // set the group manager
    function setManager(address _manager) public _isOpen {
        require(msg.sender == getDaoManager(),'no access');
        manager  = _manager;
    }


    // get the dao's manager
    function getDaoManager() public view returns(address) {
       return IDaoManager(dao).manager();
    }

    // get the user count
    function getUserCount() public view returns(uint) {
        return users.length();
    }

    // get the user by index
    function getUserByIndex(uint _index) public view returns(address) {
        return users.at(_index);
    }

     // get the verifyUsers count
    function getVerifyUserCount() public view returns(uint) {
        return verifyUsers.length();
    }

    // get the verifyUsers by index
    function getVerifyUserByIndex(uint _index) public view returns(address) {
        return verifyUsers.at(_index);
    }

    // Add the user to be approved to the Department
    function examineVerifyUser(address _user) public _isOwner _isOpen {
        require(verifyUsers.contains(msg.sender) == true,'not found this user apply');
        require(users.contains(msg.sender) == false,'Already this user');
        verifyUsers.remove(_user);
        users.add(_user);
    }

    // set the join verify
    function setJoinVerify(bool _status) public _isOwner  _isOpen {
        joinVerify = _status;
    }

    //dismiss this group
    function dismiss(address _vault) public override _isOpen {
        require(msg.sender == dao ,'no access');
        dismissStatus = true;
        uint balance = IERC20(token).balanceOf(address(this));
        TransferHelper.safeTransfer(token,_vault,balance);
    }

}
