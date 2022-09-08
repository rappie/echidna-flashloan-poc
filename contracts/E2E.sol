// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./truster/TrusterLenderPool.sol";
import "./DamnValuableToken.sol";
import "./Debugger.sol";

contract E2E {
    DamnValuableToken token;
    TrusterLenderPool pool;

    address ADDRESS_TOKEN = 0x1dC4c1cEFEF38a777b15aA20260a54E584b16C48;
    address ADDRESS_POOL = 0x1D7022f5B17d2F8B695918FB48fa1089C9f85401;

    uint256 BORROW_AMOUNT = 1000;

    address test_address;
    uint256 test_amount;

    constructor() {
        token = DamnValuableToken(ADDRESS_TOKEN);
        pool = TrusterLenderPool(ADDRESS_POOL);
    }

    // set args to be used in callback
    function setTestArgs(address _address, uint256 _amount) public {
        test_address = _address;
        test_amount = _amount;
    }

    function flashCallback() public {
        printBalance();

        // this is what echidna should find
        // token.transfer(address(pool), BORROW_AMOUNT);

        // with just the address to find it's solved within minutes
        // token.transfer(test_address, BORROW_AMOUNT);

        // no solution found yet (1 hour)
        token.transfer(test_address, test_amount);
    }

    function testFlashLoan() public {
        uint256 borrowAmount = BORROW_AMOUNT;
        address borrower = address(this);
        address target = address(this);
        bytes memory data = abi.encodeWithSignature("flashCallback()");

        // make flash loan and repay in callback
        pool.flashLoan(borrowAmount, borrower, target, data);

        // if we get here we achieved our goal, so end the test
        assert(false);
    }

    function printBalance() public {
        Debugger.log("attacker balance", token.balanceOf(address(this)));
    }
}
