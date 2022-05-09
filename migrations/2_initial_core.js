const ContractRegister = artifacts.require("ContractRegister");

module.exports = function (deployer) {
  deployer.deploy(ContractRegister);
};
