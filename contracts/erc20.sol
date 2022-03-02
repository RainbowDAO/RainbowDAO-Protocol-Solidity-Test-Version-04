pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract erc20  is ERC20{
    address public admin;
    bool public isMint;
    constructor(address _manager,uint _totalSupply,string memory _name,string memory _symbol,bool _isMint) public ERC20(_name,_symbol){
        admin = manager;
        isMint = _isMint;
        _mint(_manager, _totalSupply * 10 ** 18);
    }
    modifier  _isOwner() {
        require(msg.sender == admin);
        _;
    }
    function mint(address _user,uint _amount) public _isOwner {
        require(isMint == true,'mint is not allowed');
        _mint(_user, _amount * 10 ** 18);
    }
}
