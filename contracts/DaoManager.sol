pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
import './interface/IDepartmentFactory.sol';
import './interface/IContractRegister.sol';

contract DaoManager {
    using EnumerableSet for EnumerableSet.AddressSet;
    // store the dao base information
    struct DaoBase{
        string  name;
        string  desc;
        string  logo;
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
    }
    //todo   nft limit
    address public manager;
    DaoBase public daoBaseInfo;
    GovToken public govToken;
    JoinLimitOne public limitOne;
    JoinLimitTwo public limitTwo;
    address public creator;
    address public router;
    bool public firstSetManager;
    bool public firstSetJoinLimit;

    EnumerableSet.AddressSet private users;
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
        address _router
    ) public  {
        daoBaseInfo = DaoBase ({
            name : _name,
            desc:_desc,
            logo:_logo
        });
        govToken = GovToken ({
            token : _govToken,
            isRainbowToken:_isRainbowToken
        });
        creator = _creator;
        router = _router;
    }

    // set the dao manager
    function setManager(address _manager) public {
        if(firstSetManager == false){
            require(msg.sender == creator,'no access');
        }else{
            require(msg.sender == manager,'no access');
            firstSetManager = true;
        }
        manager = _manager;
    }
    // set the join limit
    function setJoinLimit(uint _limitType,JoinLimitOne memory _limitOne,JoinLimitTwo memory _limitTwo) public {
        if(firstSetJoinLimit == false){
            require(msg.sender == creator,'no access');
        }else{
            require(msg.sender == manager,'no access');
            firstSetJoinLimit = true;
        }
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
        require(users.contains(msg.sender) == false,'Already joined');
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

    // create a new department
    function newDepartment(string memory _name) public {
        address departmentFactoryAddr = IContractRegister(router).routers('DepartmentFactory');
        address departmentAddr = IDepartmentFactory(departmentFactoryAddr).newDepartment();
        groupCount++;
        uint id = groupCount;
        Group storage g = groups[id];
        g.id = id;
        g.name = _name;
        g.addr = departmentAddr;
    }
    // Check whether users can join
    function _checkUserJoin() internal {

    }
}
