// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface ISupraOraclePull {
    /**
     * @dev Verified price data structure.
     * @param pairs List of pairs.
     * @param prices List of prices corresponding to the pairs.
     * @param decimals List of decimals corresponding to the pairs.
     */
    struct PriceData {
        uint256[] pairs;
        uint256[] prices;
        uint256[] decimals;
    }

    /**
     * @dev Verifies oracle proof and returns price data.
     * @param _bytesproof The proof data in bytes.
     * @return PriceData Verified price data.
     */
    function verifyOracleProof(
        bytes calldata _bytesproof
    ) external returns (PriceData memory);
}

/**
 * @title Supra
 * @dev Mock contract which can consume oracle pull data.
 */
contract Supra {
    // The oracle contract
    ISupraOraclePull internal oracle;

    // Stores the latest price data for a specific pair
    mapping(uint256 => uint256) public latestPrices;
    mapping(uint256 => uint256) public latestDecimals;

    // Event to notify when a price threshold is met
    event PriceThresholdMet(uint256 pairId, uint256 price);

    /**
     * @dev Sets the oracle contract address.
     * @param oracle_ The address of the oracle contract.
     */
    constructor(address oracle_) {
        oracle = ISupraOraclePull(oracle_);
    }

    /**
     * @dev Extracts price data from the bytes proof data.
     * @param _bytesProof The proof data in bytes.
     */
    function deliverPriceData(bytes calldata _bytesProof) external {
        ISupraOraclePull.PriceData memory prices = oracle.verifyOracleProof(
            _bytesProof
        );

        // Iterate over all the extracted prices and store them
        for (uint256 i = 0; i < prices.pairs.length; i++) {
            uint256 pairId = prices.pairs[i];
            uint256 price = prices.prices[i];
            uint256 decimals = prices.decimals[i];

            // Update the latest price and decimals for the pair
            latestPrices[pairId] = price;
            latestDecimals[pairId] = decimals;

            // Example utility: Trigger an event if the price meets a certain threshold
            if (price > 1000 * (10 ** decimals)) {
                // Example threshold
                emit PriceThresholdMet(pairId, price);
            }
        }
    }

    /**
     * @dev Updates the oracle contract address.
     * @param oracle_ The new address of the oracle contract.
     */
    function updatePullAddress(address oracle_) external {
        oracle = ISupraOraclePull(oracle_);
    }

    /**
     * @dev Returns the latest price and decimals for a given pair ID.
     * @param pairId The ID of the pair.
     * @return price The latest price of the pair.
     * @return decimals The decimals of the pair.
     */
    function getLatestPrice(
        uint256 pairId
    ) external view returns (uint256 price, uint256 decimals) {
        price = latestPrices[pairId];
        decimals = latestDecimals[pairId];
    }
}
