// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/WitnessChain.sol";

contract WitnessChainTest is Test {
    WitnessChain public c;
    
    function setUp() public {
        c = new WitnessChain();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
