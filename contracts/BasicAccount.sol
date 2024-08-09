// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IAccount.sol";
import {TransactionHelper} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/TransactionHelper.sol";
import {SystemContractsCaller} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/SystemContractsCaller.sol";
import {BOOTLOADER_FORMAL_ADDRESS, NONCE_HOLDER_SYSTEM_CONTRACT, INonceHolder} from "@matterlabs/zksync-contracts/l2/system-contracts/Constants.sol";

contract BasicAccount is IAccount {
    using TransactionHelper for *;

    modifier onlyBootloader() {
        require(
            msg.sender == BOOTLOADER_FORMAL_ADDRESS,
            "Only bootloader is allowed to call this function"
        );
        _;
    }

    // Step 1: Do I want to execute the transaction based on my logic set here.
    function validateTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable onlyBootloader returns (bytes4 magic) {
        // One mandatory rule is that we increment the nonce
        SystemContractsCaller.systemCallWithPropagatedRevert(
            uint32(gasleft()),
            address(NONCE_HOLDER_SYSTEM_CONTRACT),
            0,
            abi.encodeCall(
                INonceHolder.incrementMinNonceIfEquals,
                (_transaction.nonce)
            )
        );

        // Return the magic value to indicate that the transaction is valid.
        magic = ACCOUNT_VALIDATION_SUCCESS_MAGIC;
    }

    // Step 2: If I want to execute it, let's pay the fee to the bootloader first.
    // Note: We could alternatively prepareForPaymaster and have someone else cover the fee.
    function payForTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable onlyBootloader {
        bool success = _transaction.payToTheBootloader();
        require(success, "Failed to pay the fee to the operator");
    }

    // Step 3: Once we have paid the fee to the bootloader, the transaction is executed.
    function executeTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable onlyBootloader {
        address to = address(uint160(_transaction.to));
        (bool success, ) = to.call{value: _transaction.value}(
            _transaction.data
        );

        require(success, "Failed to execute the transaction");
    }

    // This will be called instead of payForTransaction (step 2) if the transaction has a paymaster.
    function prepareForPaymaster(
        bytes32 _txHash,
        bytes32 _possibleSignedHash,
        Transaction calldata _transaction
    ) external payable onlyBootloader {
        _transaction.processPaymasterInput();
    }

    // This is related to L1 -> L2 communication. We can skip it for now.
    function executeTransactionFromOutside(
        Transaction calldata _transaction
    ) external payable onlyBootloader {}

    fallback() external {
        assert(msg.sender != BOOTLOADER_FORMAL_ADDRESS);
    }

    receive() external payable {}
}
