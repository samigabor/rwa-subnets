// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployContracts} from "../script/DeployContracts.s.sol";
import {Registry} from "../src/Registry.sol";
import {Lender} from "../src/Lender.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

/**
 * forge test --fork-url $RPC_URL
 */
contract RWATest is Test {
    Registry registry;
    Lender lender;
    HelperConfig helperConfig;

    address public deployer;
    string public borrowerId = "user1";
    address public borrower = makeAddr(borrowerId);
    string public toId = "user2";
    address public to = makeAddr(toId);
    uint256 public assetId = 123123;
    uint256 public loanAmount = 1000;

    function setUp() public {
        DeployContracts deployScript = new DeployContracts();
        (registry, lender , helperConfig) = deployScript.run();
        (deployer, ) = helperConfig.config();
    }

    ////////////////////
    // Registry tests //
    ////////////////////

    function testCreateAsset() public {
        vm.prank(deployer);
        uint256 tokenId = registry.createAsset(borrower, borrowerId, assetId);

        assertEq(registry.ownerOf(tokenId), borrower);
    }

    function testTransferAsset() public {
        vm.prank(deployer);
        uint256 tokenId = registry.createAsset(borrower, borrowerId, assetId);

        vm.prank(borrower);
        registry.transferAsset(tokenId, to, toId);

        assertEq(registry.ownerOf(tokenId), to);
    }

    function testVerifyRequest() public {
        vm.prank(deployer);
        registry.createAsset(borrower, borrowerId, assetId);

        assertEq(registry.verifyRequest(borrower, assetId), true);
    }

    //////////////////
    // Lender tests //
    //////////////////

    function testRequestLoan() public {
        // borrower submits a loan request. At this point the loan has a PENDING status
        vm.prank(borrower);
        uint256 requestId = lender.requestLoan(borrowerId, loanAmount, assetId);

        Lender.LoanRequest memory loanRequest = lender.getLoanRequest(requestId);
        assertEq(loanRequest.borrowerId, borrowerId);
        assertEq(uint256(loanRequest.status), uint256(Lender.Status.PENDING));
    }

    function testCreateLoanRejected() public {
        // borrower does NOT have a registered asset => loan REJECTED
        vm.prank(borrower);
        uint256 requestId = lender.requestLoan(borrowerId, loanAmount, assetId);
        
        vm.prank(deployer);
        lender.createLoan(requestId);

        Lender.Loan memory loan = lender.getLoan(borrower);
        assertEq(uint256(loan.status), uint256(Lender.Status.REJECTED));
    }

    function testCreateLoanApproved() public {
        // borrower has a registered asset => loan APPROVED
        vm.prank(deployer);
        registry.createAsset(borrower, borrowerId, assetId);
        vm.prank(borrower);
        uint256 requestId = lender.requestLoan(borrowerId, loanAmount, assetId);

        vm.prank(deployer);
        lender.createLoan(requestId);

        Lender.Loan memory loan = lender.getLoan(borrower);
        assertEq(uint256(loan.status), uint256(Lender.Status.APPROVED));
    }
}
