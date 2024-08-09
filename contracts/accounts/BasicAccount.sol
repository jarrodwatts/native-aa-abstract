// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IAccount.sol";
import {TransactionHelper} from "@matterlabs/zksync-contracts/l2/system-contracts/libraries/TransactionHelper.sol";

contract BasicAccount is IAccount {
    using TransactionHelper for *;

    modifier onlyBootloader() {
        assert(msg.sender == BOOTLOADER_FORMAL_ADDRESS);
        _;
    }

    function validateTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable onlyBootloader returns (bytes4 magic) {
        magic = ACCOUNT_VALIDATION_SUCCESS_MAGIC;
    }

    function payForTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable onlyBootloader {
        bool success = _transaction.payToTheBootloader();
        require(success, "Failed to pay the fee to the operator");
    }

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

    function executeTransactionFromOutside(
        Transaction calldata _transaction
    ) external payable onlyBootloader {
        bool success = _transaction.payToTheBootloader();
        require(success, "Failed to pay the fee to the operator");
    }

    function prepareForPaymaster(
        bytes32 _txHash,
        bytes32 _possibleSignedHash,
        Transaction calldata _transaction
    ) external payable onlyBootloader {
        _transaction.processPaymasterInput();
    }

    fallback() external {
        assert(msg.sender != BOOTLOADER_FORMAL_ADDRESS);
    }

    receive() external payable {}
}
