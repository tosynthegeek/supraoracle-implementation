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

    constructor(address oracle_) {
        oracle = ISupraOraclePull(oracle_);
    }
    // Extract price data from the bytes/proof data
    function deliverPriceData(bytes calldata _bytesProof) external {
        ISupraOraclePull.PriceData memory prices = oracle.verifyOracleProof(
            _bytesProof
        );

        //Iterate over all the extracted prices.
        //Do something with them!
        for (uint256 i = 0; i < prices.pairs.length; i++) {
            prices.pairs[i]; // - The pair ID at the current position.
            prices.prices[i]; //  - The price of the pair ID at the current position.
            prices.decimals[i]; // - The decimal places of the pair ID at the current position.
        }
    }

    function updatePullAddress(address oracle_) external {
        oracle = ISupraOraclePull(oracle_);
    }

    function getLatestPrice(
        uint256 pairId
    ) external view returns (uint256 price, uint256 decimals) {
        price = latestPrices[pairId];
        decimals = latestDecimals[pairId];
    }
}
