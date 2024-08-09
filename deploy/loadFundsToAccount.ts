import { parseEther } from "ethers";
import { deployContract, getWallet } from "./utils";

/**
 * Simple function to load funds to our smart account so it can pay gas fees to the bootloader.
 */
export default async function (smartAccountAddress: string) {
    const wallet = getWallet();
    const tx = await wallet.transfer({
        amount: parseEther("0.0069420"),
        to: smartAccountAddress,
    })
    console.log("Loaded funds to smart account:");
    return tx;
}
