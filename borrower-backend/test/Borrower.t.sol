// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Borrower} from "../src/Borrower.sol";

contract BorrowerTest is Test {
    Borrower public borrower;

    function setUp() public {
        borrower = new Borrower();
        //counter.setNumber(0);
    }

    function test_loanRequest() public {
        //Borrower.increment();
        //assertEq(counter.number(), 1);
    }

}
