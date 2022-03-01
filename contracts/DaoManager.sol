pragma solidity ^0.8.0;
contract DaoManager {
    // store the dao base information
    struct DaoBase{
        string  name;
        string  desc;
        string  logo;
        address token;
        bool isRainbowToken; //Is the rainbow token generated
    }
    DaoBase public daoBaseInfo;
    constructor(string memory _name,string memory _desc, string memory _logo,address _govToken, bool _isRainbowToken) public  {
        daoBaseInfo = DaoBase ({
            name : _name,
            desc:_desc,
            log:_logo,
            token:_govToken,
            isRainbowToken:_isRainbowToken
        });
    }
}
