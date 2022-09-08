// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";

import "./truster/TrusterLenderPool.sol";
import "./DamnValuableToken.sol";

contract Attacker {
    DamnValuableToken token;
    TrusterLenderPool pool;

    constructor(address _token, address _pool) {
        token = DamnValuableToken(_token);
        pool = TrusterLenderPool(_pool);
    }

    function flashCallback() public {
        printBalance();
        token.transfer(address(pool), 1000);
    }

    function testFlashLoan() public {
        uint256 borrowAmount = 1000;
        address borrower = address(this);
        address target = address(this);
        bytes memory data = abi.encodeWithSignature("flashCallback()");

        pool.flashLoan(borrowAmount, borrower, target, data);
    }

    function printBalance() public {
        console.log("attacker balance", token.balanceOf(address(this)));
    }
}
