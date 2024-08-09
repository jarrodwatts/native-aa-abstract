import { getBytes, VoidSigner, ZeroAddress } from "ethers";
import { getProvider, LOCAL_RICH_WALLETS } from "./utils";
import { serializeEip712 } from "zksync-ethers/build/utils";
import loadFundsToAccount from "./loadFundsToAccount";

// Address of the contract to interact with
const CONTRACT_ADDRESS = "0xb4104CFeaDa272629F7Af44336a1dfa0b8dC4b30";
if (!CONTRACT_ADDRESS) throw "⛔️ Provide address of the contract to interact with!";

// An example of a script to interact with the contract
// What we're doing here is:
//  1. Creating a structured object (following EIP-712) that represents the transaction we want to send
//  2. Broadcasting the transaction to the network. Once it reaches the network:
//     1. Gets picked up by the bootloader
//     2. Sent to the "from" address, which is the smart contract account we deployed.
//     3. The smart contract account run it's three functions:
//        a) validateTransaction
//        b) payForTransaction
//        c) executeTransaction
export default async function () {
  console.log(`Running script to interact with contract ${CONTRACT_ADDRESS}`);

  // Here we basically just create a transaction object that we want to send.
  // We just need it for stuff like gas estimation, nonce calculation, etc.
  const transactionGenerator = new VoidSigner(LOCAL_RICH_WALLETS[0].address, getProvider());
  const transactionFields = await transactionGenerator.populateTransaction({
    to: LOCAL_RICH_WALLETS[1].address, // As an example, let's send money to the burn address
  })
  // Also just load some funds to the smart account so it can pay for gas fees
  await loadFundsToAccount(CONTRACT_ADDRESS);

  const serializedTx = serializeEip712({
    ...transactionFields,
    from: CONTRACT_ADDRESS, // say that the transaction comes "from" the smart contract account
    customData: {
      customSignature: getBytes("0x69") // In the real world, we would sign this with a private key
      // paymasterParams
    },
  })

  const sentTx = await getProvider().broadcastTransaction(serializedTx);
  console.log("Transaction sent:", sentTx);
}
