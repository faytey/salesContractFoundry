// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import "../src/Purchase.sol";
import "../src/Properties.sol";


contract PurchaseTest is Test{
    Purchase public purchase;
    Properties public properties;

    address owner = mkaddr("owner");

    function setUp() public {
        purchase = new Purchase();
        properties = new Properties(address(purchase));
    }

    function testBalance() public {
        properties.balanceOf(address(purchase), 1);
    }

    function testPurchaseProperty() public {
        vm.deal(owner, 50 ether);
        vm.startPrank(owner);
        purchase.purchaseProperty{value: 7 ether}(1, 2);
        properties.balanceOf(owner, 1);
        vm.stopPrank();
        properties.balanceOf(address(purchase), 1);
        console.log(address(purchase).balance);
    }






       function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}