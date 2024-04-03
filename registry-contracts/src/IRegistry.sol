// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IRegistry {
    function verifyRequest(address _borrower, uint256 _assetId) external view returns (bool borrowerOwnsAsset);
}
