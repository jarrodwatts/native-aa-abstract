import * as hre from "hardhat";
import { ethers } from "ethers";
import { utils, Provider } from "zksync-ethers";
import { getProvider } from "./utils";

// Address of the contract to interact with
const CONTRACT_ADDRESS = "0x4da8b63F2Ce2331065E9EE1ED79Fe157B2Bd3286";
if (!CONTRACT_ADDRESS) throw "⛔️ Provide address of the contract to interact with!";

// An example of a script to interact with the contract
export default async function () {
  console.log(`Running script to interact with contract ${CONTRACT_ADDRESS}`);

  // Load compiled contract info
  const contractArtifact = await hre.artifacts.readArtifact("BasicAccount");

  // Initialize contract instance for interaction
  const contract = new ethers.Contract(
    CONTRACT_ADDRESS,
    contractArtifact.abi,
  );

  const provider = getProvider();

  const serializedTx = utils.serializeEip712({


  })

  const sentTx = await provider.send("eth_sendRawTransaction", [serializedTx]);
}
