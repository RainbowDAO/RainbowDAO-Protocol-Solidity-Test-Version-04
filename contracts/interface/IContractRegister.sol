pragma solidity ^0.8.0;

interface IContractRegister {
    function SaveContract(string memory _name,address _address ) external;
    function routers(string memory _name) external returns(address);
}
