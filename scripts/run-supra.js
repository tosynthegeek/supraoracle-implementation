const { ethers } = require("hardhat");
const PullServiceClient = require("../oracle-pull-example/javascript/evm_client/pullServiceClient");
require("dotenv").config();

const address = "testnet-dora.supraoracles.com";
const pairIndexes = [0, 21, 61, 49];
const sepoliaPullContractAdress = "0x6Cd59830AAD978446e6cc7f6cc173aF7656Fb917"; //Update for V1 or V2
const privateKey = process.env.PRIVATE_KEY;

async function main() {
  const client = new PullServiceClient(address);
  const request = {
    pair_indexes: pairIndexes,
    chain_type: "evm",
  };

  console.log("Getting proof....");

  const proof = client.getProof(request, (err, response) => {
    if (err) {
      console.error("Error getting proof:", err.details);
      return;
    }
    console.log("Calling contract to verify the proofs.. ");
    callContract(response.evm);
  });
}

async function callContract(response) {
  const Supra = await ethers.getContractFactory("Supra");
  const supra = await Supra.deploy(sepoliaPullContractAdress);
  const contractAddress = await supra.getAddress();

  console.log("Supra deployed to: ", contractAdress);

  const hex = ethers.hexlify(response);

  const txData = await supra.deliverPriceData(hex);
  const gasEstimate = await supra.estimateGas.deliverPriceData(hex);
  const gasPrice = await ethers.provider.getGasPrice();

  console.log("Estimated gas for deliverPriceData:", gasEstimate.toString());
  console.log("Estimated gas price:", gasPrice.toString());

  const tx = {
    from: "0xDA01D79Ca36b493C7906F3C032D2365Fb3470aEC",
    to: contractAddress,
    data: txData,
    gas: gasEstimate,
    gasPrice: gasPrice,
  };

  const wallet = new ethers.Wallet(privateKey);
  const signedTransaction = await wallet.signTransaction(tx);
  const txResponse = await wallet.sendTransaction(tx);
  console.log("Transaction sent! Hash:", txResponse.hash);

  // (Optional) Wait for transaction confirmation (e.g., 1 block confirmation)
  const receipt = await txResponse.wait(1);
  console.log("Transaction receipt:", receipt);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
