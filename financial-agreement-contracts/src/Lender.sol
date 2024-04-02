// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Lender is Ownable {
    // private variables
    uint256 private _loan_ids;
    uint256 private _request_ids;

    enum Status {
        REQUEST, // Initial status by default
        PENDING, // When the Loan request is under reviews
        APPROVED, // When the load had been approve
        REJECTED // when the loan is rejected

    }

    struct Loan {
        Status loan_state;
        address borrower;
        bytes32 agreement_hash;
        uint8 loan_amount_term;
        uint8 credit_history;
        uint256 loan_id;
        uint256 approved_amount;
        uint256 applicant_biz_income;
        uint256 prop_accessment_per_acre;
        string property_type;
        string property_area;
        string biz_id;
        mapping(address => bool) owners;
    }

    struct LoanRequest {
        bool verification_status;
        address borrower;
        bytes32 document_hash;
        uint8 acres;
        uint256 amount;
        uint256 property_RegId;
        uint256 survey_zip_code;
        uint256 survey_number;
        uint256 request_id;
    }

    mapping(address => mapping(uint256 => LoanRequest)) public requestList;
    mapping(address => mapping(uint256 => Loan)) public loanList;

    //constructor
    constructor() Ownable(msg.sender) {}

    function loanRequest(
        address _borrower,
        bytes32 _document_hash,
        uint8 _acres,
        uint256 _amount,
        uint256 _property_RegId,
        uint256 _survey_zip_code,
        uint256 _survey_number
    ) external returns (Status) {
        requestList[msg.sender][_request_ids] = LoanRequest(
            false,
            _borrower,
            _document_hash,
            _acres,
            _amount,
            _property_RegId,
            _survey_zip_code,
            _survey_number,
            _request_ids
        );
        _request_ids++;
        return Status(1);
    }

    function create_loan(
        bytes32 _agreement_hash,
        address _borrower,
        uint8 _loan_amount_term,
        uint8 _credit_history,
        uint256 _approved_amount,
        uint256 _applicant_biz_income,
        uint256 _prop_accessment_per_acre,
        string memory _biz_id,
        string memory _property_type,
        string memory _property_area
    ) public {
        loanList[msg.sender][_loan_ids].loan_state = Status(1);
        loanList[msg.sender][_loan_ids].borrower = _borrower;
        loanList[msg.sender][_loan_ids].agreement_hash = _agreement_hash;
        loanList[msg.sender][_loan_ids].loan_amount_term = _loan_amount_term;
        loanList[msg.sender][_loan_ids].credit_history = _credit_history;
        loanList[msg.sender][_loan_ids].loan_id = _loan_ids;
        loanList[msg.sender][_loan_ids].approved_amount = _approved_amount;
        loanList[msg.sender][_loan_ids].applicant_biz_income = _applicant_biz_income;
        loanList[msg.sender][_loan_ids].prop_accessment_per_acre = _prop_accessment_per_acre;
        loanList[msg.sender][_loan_ids].property_type = _property_type;
        loanList[msg.sender][_loan_ids].property_area = _property_area;
        loanList[msg.sender][_loan_ids].biz_id = _biz_id;
        loanList[msg.sender][_loan_ids].owners[owner()] = false;
        loanList[msg.sender][_loan_ids].owners[_borrower] = false;
        _loan_ids++;
    }

    // verification request
    function verification_request() public onlyOwner {
        //number++;
    }
}
