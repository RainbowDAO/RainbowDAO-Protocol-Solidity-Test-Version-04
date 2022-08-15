// SPDX-License-Identifier: Apache
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './interface/IDepartmentFactory.sol';
import './interface/IContractRegister.sol';
import './interface/IDaoManager.sol';
import './interface/IDaoVaultFactory.sol';
import './interface/IDepartment.sol';
import './interface/IUnionDaoFactory.sol';
import './interface/IUnionDao.sol';
import './interface/IDaoFactory.sol';
import './lib/TransferHelper.sol';

contract DaoManager is IDaoManager {
    using EnumerableSet for EnumerableSet.AddressSet;
    // store the dao base information
    struct DaoBase{
        string  name;
        string  desc;
        string  logo;
        uint daoType;//1 independent 2 union 3 child 4 union&child
    }
    // store the government token
    struct GovToken {
        address token;
        bool isRainbowToken; //Is the rainbow token generated
    }
    // join limit types
    uint public limitType;
    // struct ComponentsAddrs {

    // }

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
    struct Group {
        uint id;
        string name;
        address addr;
        bool dismiss;
    }
    //todo   nft limit
    address public override manager;
    bool public dismiss;
    DaoBase public daoBaseInfo;
    GovToken public govToken;
    JoinLimitOne public limitOne;
    JoinLimitTwo public limitTwo;

    address public router;
    // the vault address
    address public vault;
    // All the alliances this Dao joins
    EnumerableSet.AddressSet private unionDaos;

    EnumerableSet.AddressSet private users;

    address public parentDao;

    // List of child Daos audited as parent and child Daos
    EnumerableSet.AddressSet private pendIngChildDaos;
    // ceremonial child daos
    EnumerableSet.AddressSet private childDaos;
    // Group[]  groups;
    mapping(uint => Group) public  groups;
    uint public groupCount;
    constructor(
        string memory _name,
        string memory _desc,
        string memory _logo,
        address _govToken,
        bool _isRainbowToken,
        address _creator,
        address _router,
        uint _daoType,
        address _parentDao
    ){
        daoBaseInfo = DaoBase ({
            name : _name,
            desc:_desc,
            logo:_logo,
            daoType:_daoType

        });
        govToken = GovToken ({
            token : _govToken,
            isRainbowToken:_isRainbowToken
        });
       manager = _creator;
       router = _router;
       if(_daoType == 2 || _daoType == 4){
           _createUnion(_name);
       }
       if(_parentDao != address(0)) {
           parentDao = _parentDao;
           IDaoManager(_parentDao).addPendingChildDao(address(this));
       }
    }
    modifier  _isOwner() {
        require(msg.sender == manager);
        _;
    }

    // set the dao manager
    function setManager(address _manager) public _isOwner {
        manager = _manager;
    }

    // set the join limit
    function setJoinLimit(uint _limitType,JoinLimitOne memory _limitOne,JoinLimitTwo memory _limitTwo) public _isOwner{
        limitType = _limitType;
        if(_limitType == 1){
            limitOne = _limitOne;
        }else if(_limitType == 2){
            limitTwo = _limitTwo;
        }else if(_limitType == 4) {
            limitOne = _limitOne;
            limitTwo = _limitTwo;
        }
    }

    // user join dao
    function joinDao() public {
        _checkUserJoin();
        require(checkUserExists(msg.sender) == false,'Already joined');
        users.add(msg.sender);
    }

    // get all user
    // todo uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     /*   function getUserList() public view returns(address[]) {
            address[] lists;
            uint userLength = users.length();
            for (uint i = 0; i < userLength; i++) {
                address user = users.at(i);
                lists.push(user);
            }
            return lists;
        }*/

    // get user length
    function getUserLength() public view returns(uint) {
        return users.length();
    }
    // get user index
    function getUserByIndex(uint index) public view returns(address) {
        return users.at(index);
    }

    function leaveDao() public {
        users.remove(msg.sender);
    }
    function addPendingChildDao(address _dao) public override{
        pendIngChildDaos.add(_dao);
    }
    // create a new department
    function newDepartment(string memory _name,string memory _logo) public _isOwner returns(address){
        address departmentFactoryAddr = IContractRegister(router).routers('DepartmentFactory');
        address departmentAddr = IDepartmentFactory(departmentFactoryAddr).newDepartment(_name,_logo);
        groupCount++;
        uint id = groupCount;
        Group storage g = groups[id];
        g.id = id;
        g.name = _name;
        g.addr = departmentAddr;
        return departmentAddr;
    }
    // Check whether users can join
    function _checkUserJoin() internal {
        if(limitType == 1) {
            _checkOneLimit();
        }else if(limitType == 2){
            _checkTwoLimit();
        }else if(limitType == 4){
            _checkOneLimit();
            _checkTwoLimit();
        }
    }

    function _checkOneLimit() internal {
        require(IERC20(limitOne.token).balanceOf(msg.sender) >= limitOne.tokenAmount,'not enough amount');
        address to = vault == address(0) ? address(this) : vault;
        TransferHelper.safeTransferFrom(limitOne.token,msg.sender,to,limitOne.tokenAmount);
    }
    function _checkTwoLimit() internal view {
        require(IERC20(limitTwo.token).balanceOf(msg.sender) >= limitTwo.holderAmount,'not enough amount');
    }

    //Check whether the user exists
    function checkUserExists(address _user) public override view returns(bool) {
        return users.contains(_user);
    }

    // dismiss a group
    function dismissDepartment(uint _id) public _isOwner {
        require(vault != address(0),'Vault has not been created');
        groups[_id].dismiss = true;
        IDepartment(groups[_id].addr).dismiss(vault);
    }

    // create a vault
    function createVault() public {
        require(vault == address(0),'Already create');
        address vaultFactoryAddr = IContractRegister(router).routers('DaoVaultFactory');
        address vaultAddr = IDaoVaultFactory(vaultFactoryAddr).newVault();
        vault = vaultAddr;
    }
    // create a  union dao
    function _createUnion(string memory _name) internal {
        address UnionDaoFactoryAddr = IContractRegister(router).routers('UnionDaoFactory');
        address unionDaoAddr = IUnionDaoFactory(UnionDaoFactoryAddr).newUnionDao(_name);
        unionDaos.add(unionDaoAddr);
    }
    // check exists uniondao
    function existsUnionDao(address _unionDao) public override view returns(bool){
        return unionDaos.contains(_unionDao);
    }

    // join a union dao
    function joinUnionDao(address _unionDao) public _isOwner {
        require(existsUnionDao(_unionDao) == false ,'exists this unionDao');
        IUnionDao(_unionDao).join();
        unionDaos.add(_unionDao);
    }
    // create a child dao
    function createChildDao(
        string memory _name,
        string memory _desc,
        string memory _logo,
        address _govToken,
        bool _isRainbowToken,
        address _manager
        ) public _isOwner {
        address DaoFactoryAddr = IContractRegister(router).routers('DaoFactory');
        address newDaoAddr = IDaoFactory(DaoFactoryAddr).newDao(_name,_desc,_logo,_govToken,_isRainbowToken,_manager,3,address(this));
        childDaos.add(newDaoAddr);
    }

}

