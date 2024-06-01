// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface ISupraOraclePull {
    //Verified price data
    struct PriceData {
        // List of pairs
        uint256[] pairs;
        // List of prices
        // prices[i] is the price of pairs[i]
        uint256[] prices;
        // List of decimals
        // decimals[i] is the decimals of pairs[i]
        uint256[] decimals;
    }

    function verifyOracleProof(
        bytes calldata _bytesproof
    ) external returns (PriceData memory);
}

// Mock contract which can consume oracle pull data
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
}

// const txData = contract.methods.deliverPriceData(hex).encodeABI(); // function from you contract eg: deliverPriceData
// const gasEstimate = await contract.methods.deliverPriceData(hex).estimateGas({from: walletAddress});
