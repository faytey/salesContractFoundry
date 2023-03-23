// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "../src/Purchase.sol";
import "../src/Properties.sol";


contract PurchaseTest is Test{
    Purchase public purchase;
    Properties public properties;
    uint256 mainnetFork;
    // string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");


    address owner = mkaddr("owner");

    function setUp() public {
        purchase = new Purchase();
        properties = new Properties(address(purchase));
        mainnetFork = vm.createFork('https://eth-mainnet.g.alchemy.com/v2/lh2i9x_uHZnURi_yOJnAU49bIQWDsJ-w');
    }

     function testCanSelectFork() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);

        // from here on data is fetched from the `mainnetFork` if the EVM requests it and written to the storage of `mainnetFork`
    }

    function testBalance() public {
        properties.balanceOf(address(purchase), 1);
        properties.balanceOf(address(purchase), 2);
    }

    function testGetUSDC() public returns (int256) {
        testCanSelectFork();
        (, int256 basePrice, , , ) = AggregatorV3Interface(
            0x986b5E1e1755e3C2440e960477f25201B0a8bbD4
        ).latestRoundData();

        return basePrice;
    }

    function testPurchasePropertyWithETH() public {
        vm.deal(owner, 50 ether);
        properties.balanceOf(address(purchase), 1);
        vm.startPrank(owner);
        purchase.purchasePropertyWithETH{value: 7 ether}(1, 2);
        properties.balanceOf(owner, 1);
        vm.stopPrank();
        properties.balanceOf(address(purchase), 1);
        console.log(address(purchase).balance);
    }

    function testGetPriceFeeds() public {
        testCanSelectFork();
        purchase.getUSDC();
        purchase.getDAI();
        purchase.getLINK();
        purchase.getUNI();
        purchase.getUSDT();
    }

    function testPurchaseWithUSDC() public {
        vm.prank(owner);
        purchase.purchaseWithUSDC(2,1);
        console.log(properties.balanceOf(address(purchase), 2));
    }
    function testPurchaseWithDAI() public {
        vm.prank(owner);
        purchase.purchaseWithDAI(1,1);
        console.log(properties.balanceOf(address(purchase), 1));
    }

    function testPurchaseWithLINK() public {
        vm.prank(owner);
        purchase.purchaseWithLINK(2,1);
        console.log(properties.balanceOf(address(purchase), 2));
    }

    function testPurchaseWithUSDT() public {
        vm.prank(owner);
        purchase.purchaseWithUSDT(1,1);
        console.log(properties.balanceOf(address(purchase), 1));
    }

    function testPurchaseWithUNI() public {
        vm.prank(owner);
        purchase.purchaseWithUNI(2,1);
        console.log(properties.balanceOf(address(purchase), 2));
    }






       function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}