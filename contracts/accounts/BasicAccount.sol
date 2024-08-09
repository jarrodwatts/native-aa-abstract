// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IAccount.sol";

contract BasicAccount is IAccount {
    /// @notice Called by the bootloader to validate that an account agrees to process the transaction
    /// (and potentially pay for it).
    /// @param _txHash The hash of the transaction to be used in the explorer
    /// @param _suggestedSignedHash The hash of the transaction is signed by EOAs
    /// @param _transaction The transaction itself
    /// @return magic The magic value that should be equal to the signature of this function
    /// if the user agrees to proceed with the transaction.
    /// @dev The developer should strive to preserve as many steps as possible both for valid
    /// and invalid transactions as this very method is also used during the gas fee estimation
    /// (without some of the necessary data, e.g. signature).
    function validateTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable returns (bytes4 magic) {
        // TODO
    }

    // Mandatory and will be called by the system after the fee is charged from the user
    function executeTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable {
        // TODO
    }

    // There is no point in providing possible signed hash in the `executeTransactionFromOutside` method,
    // since it typically should not be trusted.
    function executeTransactionFromOutside(
        Transaction calldata _transaction
    ) external payable {
        // TODO
    }

    // Is optional and will be called by the system if the transaction has no paymaster,
    // i.e. the account is willing to pay for the transaction.
    // This method should be used to pay for the fees by the account.
    // Note, that if your account will never pay any fees and will always rely on the paymaster feature, you don't have to implement this method.
    // This method must send at least tx.gasprice * tx.gasLimit ETH to the bootloader address.
    function payForTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable {
        // TODO
    }

    // is optional and will be called by the system if the transaction has a paymaster, 
    // i.e. there is a different address that pays the transaction fees for the user. 
    // This method should be used to prepare for the interaction with the paymaster. 
    // One of the notable examples where it can be helpful is to approve the ERC-20 tokens for the paymaster.
    function prepareForPaymaster(
        bytes32 _txHash,
        bytes32 _possibleSignedHash,
        Transaction calldata _transaction
    ) external payable {
        // TODO
    }
}
