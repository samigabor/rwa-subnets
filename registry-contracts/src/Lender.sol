// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import {IRegistry} from "./IRegistry.sol";

contract Lender is Ownable {
    enum Status {
        NONE, // Initial status by default
        PENDING, // Loan request is under review
        APPROVED,
        REJECTED
    }

    struct LoanRequest {
        uint256 id;
        address borrower;
        string borrowerId;
        uint256 amount;
        uint256 assetId;
        Status status;
    }

    struct Loan {
        uint256 id;
        address borrower;
        string borrowerId;
        uint256 amount;
        Status status;
    }

    IRegistry registry;
    mapping(uint256 requestId => LoanRequest) public requests;
    mapping(address borrower => Loan) public loans;

    uint256 private _loanId;
    uint256 private _requestId;

    constructor(address _registry) Ownable(msg.sender) {
        registry = IRegistry(_registry);
    }

    /**
     * @dev Request a loan from the lender
     * @param _borrowerId The id of the borrower
     * @param _amount The amount of the loan
     * @return requestId The id of the request
     */
    function requestLoan(string calldata _borrowerId, uint256 _amount, uint256 _assetId)
        external
        returns (uint256 requestId)
    {
        requestId = ++_requestId;
        requests[_requestId] = LoanRequest({
            id: requestId,
            borrower: msg.sender,
            borrowerId: _borrowerId,
            amount: _amount,
            assetId: _assetId,
            status: Status.PENDING
        });
    }

    /**
     * @dev Create a loan for a given request
     * @param requestId The id of the request
     * @return loanId The id of the loan
     */
    function createLoan(uint256 requestId) public onlyOwner returns (uint256 loanId) {
        loanId = ++_loanId;
        LoanRequest memory request = requests[requestId];
        Loan memory loan = Loan({
            id: loanId,
            borrower: request.borrower,
            borrowerId: request.borrowerId,
            amount: request.amount,
            status: request.status
        });

        bool borrowerOwnsAsset = registry.verifyRequest(request.borrower, request.assetId);
        if (borrowerOwnsAsset) {
            loan.status = Status.APPROVED;
        } else {
            loan.status = Status.REJECTED;
        }

        loans[request.borrower] = loan;
    }
}
