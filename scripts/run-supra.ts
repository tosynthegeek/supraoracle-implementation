import { ethers } from "hardhat";

async function main() {
  const sepoliaPullContractAdress = ""; //Update for V1 or V2
  const Supra = await ethers.getContractFactory("Supra");
  const supra = await Supra.deploy(sepoliaPullContractAdress);
  console.log("Supra deployed to: ", await supra.getAddress());
}
