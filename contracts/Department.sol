pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';
contract Department {
    using EnumerableSet for EnumerableSet.AddressSet;

    //Address of the Dao to which it belongs
    address public dao;
    EnumerableSet.AddressSet private users;
    constructor(address _dao) public {
        dao = _dao;
    }

    function joinGroup() public {
        require(users.contains(msg.sender) == false,'Already joined');
        users.add(msg.sender);
    }
    function leaveDao() public {
        users.remove(msg.sender);
    }


}
