// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IAccount.sol";

contract BasicAccount is IAccount {
    function validateTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable returns (bytes4 magic) {
        // TODO
    }

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

    function payForTransaction(
        bytes32 _txHash,
        bytes32 _suggestedSignedHash,
        Transaction calldata _transaction
    ) external payable {
        // TODO
    }

    function prepareForPaymaster(
        bytes32 _txHash,
        bytes32 _possibleSignedHash,
        Transaction calldata _transaction
    ) external payable {
        // TODO
    }
}
