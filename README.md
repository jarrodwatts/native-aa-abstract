# zkSync Hardhat project template

This project was scaffolded with [zksync-cli](https://github.com/matter-labs/zksync-cli).

## Local Development

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repository.

    ```bash
    git clone https://github.com/jarrodwatts/native-aa-abstract
    ```
2. Install dependencies.

    ```bash
    npm install
    ```
3. Use [Hardhat](https://hardhat.org/) to run `npm run compile` and compile the smart contracts

## Deploy & Use the Smart Contract Wallet

To demo the code, deploy and submit a transaction from the smart contract wallet, by:

1. Compiling the contracts.

    ```bash
    npm run compile
    ```

2. Install the ZKsync CLI

    ```bash
    npm install -g zksync-cli
    ```

3. For local development, ensure [Docker](https://docs.docker.com/get-docker/) is installed and running.

    ```bash
    docker --version
    docker info
    ```

4. For local development, run an "In Memory node".

    ```bash
    zksync-cli dev start
    ```

5. Create a `.env` file with the following content at the root of the project. The private key is a loaded test account on the local node. You can find those rich accounts in the `LOCAL_RICH_WALLETS` variable in the [utils.ts](./deploy/utils.ts) file.

    ```bash
    WALLET_PRIVATE_KEY=0x7726827caac94a7f9e1b160f7ea819f172f7b6f9d2a97f992c38edeab82d4110
    ```

    **IMPORTANT: NEVER PUT PRIVATE KEYS WITH REAL MONEY IN THE `.env` FILE.**

6. Deploy the contracts. *Note* the `defaultNetwork` inside [hardhat.config.ts](./hardhat.config.ts) is set to `inMemoryNode` (i.e. the one running in Docker). If you want to deploy to another network, configure the `hardhat.config.ts` file accordingly.

    ```bash
    npm run deploy
    ```

7. Take the outputted `Contract address` and paste it on line `7` of the [interact.ts](./deploy/interact.ts) file:

    ```typescript
    const CONTRACT_ADDRESS = "<your-deployed-contract-address-here>";
    ```

8. Interact with the deployed contract.

    ```bash
    npm run interact
    ```
    This will submit a transaction to the network that your deployed smart contract wallet will execute.

## Useful Links

- [Docs](https://docs.abs.xyz/)
- [Official Site](https://abs.xyz/)
- [GitHub](https://github.com/Abstract-Foundation)
- [X](https://x.com/AbstractChain)
- [Discord](https://discord.com/invite/abstractchain)

## License

This project is under the [MIT](./LICENSE) license.