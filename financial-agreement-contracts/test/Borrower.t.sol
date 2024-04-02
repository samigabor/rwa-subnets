// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";

import {Borrower} from "../src/Borrower.sol";

contract BorrowerTest is Test {
    Borrower public borrower;

    function setUp() public {
        borrower = new Borrower(msg.sender);
    }

    function test_loanRequest() public {
        //assertEq(counter.number(), 1);
    }

}
