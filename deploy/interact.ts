import { getBytes, VoidSigner } from "ethers";
import { getProvider, getWallet, LOCAL_RICH_WALLETS } from "./utils";
import { serializeEip712 } from "zksync-ethers/build/utils";
import loadFundsToAccount from "./loadFundsToAccount";

// Address of the contract to interact with
const CONTRACT_ADDRESS = "0x22D795D50060cD5e09B08D7EBe52065dd8F43aA1";
if (!CONTRACT_ADDRESS) throw "⛔️ Provide address of the contract to interact with!";

// What we're doing here is:
//  1. Creating a structured object (following EIP-712) that represents the transaction we want to send
//  2. Broadcasting the transaction to the network. Once it reaches the network, it:
//     1. Gets picked up by the bootloader
//     2. The bootloader sends it to the "from" address, which we set to the smart contract account we deployed (line 7)
//     3. The smart contract account (BasicAccount.sol) runs it's three functions in this order:
//        a) validateTransaction
//        b) payForTransaction
//        c) executeTransaction
export default async function () {
  console.log(`Running script to interact with contract ${CONTRACT_ADDRESS}`);

  // Here we are just creating a transaction object that we want to send to the network.
  // We just need it for stuff like gas estimation, nonce calculation, etc.
  const transactionGenerator = new VoidSigner(getWallet().address, getProvider());
  const transactionFields = await transactionGenerator.populateTransaction({
    to: LOCAL_RICH_WALLETS[1].address, // As an example, let's send money to another wallet for our tx.
  })

  // Send some funds to the smart contract account so it can pay for gas fees.
  await loadFundsToAccount(CONTRACT_ADDRESS);

  const serializedTx = serializeEip712({
    ...transactionFields, // All the fields like gasLimit, gasPrice, etc. from the above code.
    nonce: 1, // You may need to change this if you're sending multiple transactions.
    from: CONTRACT_ADDRESS, // Say that the transaction comes "from" the smart contract account
    customData: {
      customSignature: getBytes("0x69") // In the real world, we would sign this with a private key. Since our contract does no validation, we can put anything.
    },
  })

  const sentTx = await getProvider().broadcastTransaction(serializedTx);
  console.log("Transaction sent:", sentTx);
}
