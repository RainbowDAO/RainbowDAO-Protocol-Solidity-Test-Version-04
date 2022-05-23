// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/AggregatorV3Interface.sol";
import "./interface/IChainLinkOracle.sol";

contract ChainLinkOracle is IChainLinkOracle{

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
    constructor() {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
        /*uint80 roundID*/,
        int price,
        /*uint startedAt*/,
        /*uint timeStamp*/,
        /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return price;
    }

    function calculatePrice(uint fee) override public view returns(uint){
        (,int price,,,) = priceFeed.latestRoundData();
        uint nowPrice = uint(price) * 10 ** 10;
        uint amount = fee / nowPrice;
        return amount;
    }
}
